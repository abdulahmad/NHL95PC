; The title. The demo that runs from the title screen, the Pioneer and EA Sports logos, the title screen,
; the credits, and the text drawn over them (95G front/title95).
bits 32
%include "hockey.inc"
section s_15D6B progbits alloc exec nowrite align=1
extern __CHK, __STOSB, _dos_gettime_, _nfree_, _nmalloc_, awscore, awtmline, awtmstruct
extern byte_D42C3, awayremap, awayremap_e43, awayremap_eFF, homeremap, homeremap_e43, homeremap_eFF, cddriveptr
extern ClearInputQueue, clockcolon, clockdigits, cont2team, crestnames, ctlavailmask, cupseries, demomode
extern DemoSetupStub, demoteammode, DrawHudPanel, DrawPanelClock, DrawPanelLine_x, DrawPanelScore, dword_C4CFC, panelprevmin
extern panelprevsec, panelprevhund, panelhund, hmpanellines, awpanellines, hmpanelpens, awpanelpens, hmlinetimer
extern awlinetimer, demomatchups_m1, demomatchups, nhlintrosaid, demoflag, cursndbank, dword_DC2B8, titlesample
extern energywarn, exhstate, FadeOutPalCycle, FadePalStep, fileoncd, fontcolor, fputchar, FreeMemBlock
extern Gameloop, gamemode, gameopts, gamepal, gameresult, GetPeriodTime, GetTicks, hmscore
extern hmtmline, hmtmstruct, HomeTeam, hudawayline, hudclockhund, hudclockmin, hudclocksec, hudhomeline
extern InitGameSummary, InitSpeechSlots, InputInstall, InputRemove, introskipped, joyq_flush, kaufmfont, lcblink
extern lcboxon, lcline, linesprites, LoadModeState, LoadRink, LoadRockMusic, LoadScheduleDB, LoadTeamPalette
extern mainfont, MakePath, memcpy_, memset_, mousebtns, mousepollfn, musichandle, musicon
extern musicslot, hudotname, creditpages, PaGoodnight, PaNhlIntro, PaOpenBank, PaPreloadClips, penaltydigits
extern perioddigits, PerTimeTab, PlayDigiSample, pointerspr, PollKey, rand_, randomd0, ReloadGameGfx
extern seed, SelectScreenBM, SeriesLength, SetDrawBitmap, SetScreenSize, SetTickDeadline, SetupControllers, SetupDemoGame
extern ShowLoadingScreen, songdata, sounddev, speechbank, SpeechStopQueue, sprintf_, srand_, StopDigiSample
extern str_Adtitle, str_Backwin, str_Bkgd3, str_Cmv, str_Credits, str_Crests4, str_Eaopen, str_Eascrn
extern str_Easports, str_FlaD, str_Iff2, str_KMS, str_MASK, str_Msk1, str_Mttitle, str_Pal4
extern str_Pio, str_Pion, str_Pioneer1, str_Pioneer2, str_Pioneer3, str_Pioneer4, str_Pl1, str_Pl2
extern str_PPV, str_Rockditi, str_Scrbrd2, str_Scrn2, str_Shp0, str_Srb3, str_Stanley, str_Title
extern str_Title30, strlen_, sub_1AC25, sub_1ACF1, sub_1AD16, sub_1B002, sub_1B092, sub_1B09F
extern sub_1B0AD, sub_1B0BB, sub_1B0C9, sub_1B0D7, sub_1B0E5, sub_1B0F3, sub_1B18B, sub_1B1C2
extern sub_1B2A7, sub_1B8AC, sub_1B92E, AllocMemBlock, sub_8D2F0, LoadBank, sub_8E8A0, TextSaveState
extern TextRestoreState, TextSetFont, LoadSample, FreeSample, sub_8F98F, sub_8FB8E, SndQuery, sub_8FCDF
extern PutBlock, DrawBitmap, sub_9087C, FillRect, sub_9121C, sub_91284, sub_912C8, sub_9132C
extern DrawArt, DrawShape, GrabBlock, PrintString, FindShape, ReadJoyRaw, ClearScreen, sub_B3A88
extern sub_B3AA1, VgaSetPalette, sub_B4BA8, sub_B4CD8, sub_B4CF2, SetColorRemap, sub_B4E50, CreateBitmap
extern teamabbrevs, teamdivflags, textcolor, textgrid, textgridon, textoutlinedx, textoutlinedy, textshadow
extern TickDeadlinePassed, TicksSinceLastCall, blackpal, unk_C638C, UpdateHudPanel_x, VisTeam, WaitClickTimeout, WaitTickDeadline
extern lcsel_aw
global RunDemoGame, RunDemoGame_x, AnyInputPressed, ReadBE32, TitleScreen, RunIntro, ShowCredits, SetTextColors
global RenderTextLine, PrintCenteredText, PrintShadowText, PrintOutlinedText, PrintFmt1, PrintFmt2, TextGridOpen, TextGridFree
global TextGridOff, TextGridPut
;-----------------------------------------------------------------------------
; RunDemoGame                                                     15D6B  95 PC
; Attract-mode demo from the title screens: picks random teams / options,
; sets demomode, loads the exhibition mode state, ReloadGameGfx,
; SetupGameQuick, DrawHudPanel, GameLoop, then restores the screen size and
; mode state and clears demomode
;-----------------------------------------------------------------------------
; C: src/front/title/RunDemoGame.c
%ifdef CBUILD
%include "c/front/title/RunDemoGame.inc"
%else
RunDemoGame:
        push dword 94h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 78h
        call ShowLoadingScreen
        call InputRemove
        mov word [PerTimeTab], 3Ch
        call DemoSetupStub
        mov dword [demomode], 1
        call rand_
        mov edx, eax
        shl edx, 10h
        call rand_
        add edx, eax
        mov dword [seed], edx
        mov edx, dword [demoteammode]
        inc edx
        mov ebx, 3
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov dword [demoteammode], edx
        mov ecx, 1Dh
        mov edi, esp
        mov esi, exhstate
        rep movsd
        movsb
        cmp edx, byte 2
        jne short .1
        mov dword [exhstate+51h], 1Bh
        mov dword [exhstate+55h], 1Ah
        jmp short .3
.1:
        cmp edx, byte 1
        jne short .2
        mov eax, 11h
        call randomd0
        movsx edx, ax
        mov eax, dword [nosplit edx*2+demomatchups_m1]
        sar eax, 18h
        mov dword [exhstate+51h], eax
        mov eax, dword [nosplit edx*2+demomatchups]
        sar eax, 18h
        mov dword [exhstate+55h], eax
        jmp short .3
.2:
        call rand_
        mov edx, eax
        mov ebx, 1Ah
        sar edx, 1Fh
        idiv ebx
        mov dword [exhstate+51h], edx
        inc edx
        mov eax, 19h
        call randomd0
        cwde
        add edx, eax
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov dword [exhstate+55h], edx
.3:
        mov ebp, 10h
        mov dword [exhstate+65h], ebp
        xor eax, eax
        mov dword [gamemode], eax
        mov dword [exhstate+69h], ebp
        mov dword [exhstate+6Dh], eax
        mov dword [exhstate+71h], 1
        mov eax, dword [exhstate+51h]
        mov dword [exhstate+5Dh], eax
        mov dword [exhstate+5Dh], 0FFFFFFFFh
        mov dword [exhstate+61h], 0FFFFFFFEh
        mov eax, exhstate
        call LoadModeState
        or byte [gameopts], 0FFh
        cmp byte [musicon], 0
        je short .4
        or byte [gameopts+1], 1
        jmp short .5
.4:
        and byte [gameopts+1], 0FEh
.5:
        mov bh, byte [gameopts+1]
        or bh, 2
        mov byte [gameopts+1], bh
        mov cl, bh
        and cl, 3
        mov byte [gameopts+1], cl
        mov edx, dword [VisTeam-2]
        sar edx, 10h
        mov edx, dword [nosplit edx*4+teamabbrevs]
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
        mov eax, dword [nosplit eax*4+teamabbrevs]
        call PaPreloadClips
        call SetupControllers
        xor edx, edx
        xor eax, eax
        call InitGameSummary
        cmp word [HomeTeam], byte 1Ah
        jl short .6
        mov eax, 0Ch
        jmp short .7
.6:
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
.7:
        call LoadRink
        call LoadRockMusic
        call ReloadGameGfx
        call FadeOutPalCycle
        mov ebp, 1
        mov dword [demoflag], ebp
        call SetupDemoGame
        xor eax, eax
        mov dword [demoflag], eax
        mov dword [introskipped], eax
        mov dword [gameresult], eax
        mov edx, 0C8h
        mov eax, 140h
        call SetScreenSize
        mov edx, dword [VisTeam-2]
        sar edx, 10h
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
        mov ebx, gamepal
        call LoadTeamPalette
        mov edx, dword [VisTeam-2]
        sar edx, 10h
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
        mov ecx, ebp
        mov ebx, ebp
        call DrawHudPanel
        call joyq_flush
        call Gameloop
        mov edx, 1E0h
        mov eax, 280h
        call SetScreenSize
        mov word [PerTimeTab], 12Ch
        xor ecx, ecx
        mov dword [demomode], ecx
        mov ecx, 1Dh
        mov edi, exhstate
        mov esi, esp
        rep movsd
        movsb
        mov eax, exhstate
        call LoadModeState
        call InputInstall
        cmp dword [gameresult], byte 2
        sete al
        and eax, 0FFh
        add esp, byte 78h
RunDemoGame_x:
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; AnyInputPressed                              1600C  95 PC, medium confidence
; Returns 1 for a key (PollKey), a joystick button (bits 30h of ReadJoyRaw
; for each present stick) or a mouse button; used to break the demo and the
; MVI movies
;-----------------------------------------------------------------------------
; C: src/front/title/AnyInputPressed.c
%ifdef CBUILD
%include "c/front/title/AnyInputPressed.inc"
%else
AnyInputPressed:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        call PollKey
        mov esi, eax
        test eax, eax
        jne short .3
        mov ah, byte [ctlavailmask]
        test ah, 2
        jne short .1
        test ah, 4
        je short .3
.1:
        call ReadJoyRaw
        test al, 30h
        jne short .2
        sar eax, 8
        test al, 30h
        je short .3
.2:
        mov esi, 1
.3:
        test esi, esi
        jne short .4
        test byte [ctlavailmask], 1
        je short .4
        call dword [mousepollfn]
        test byte [mousebtns], 3
        je short .4
        mov esi, 1
.4:
        mov eax, esi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ReadBE32                                                        16072  95 PC
; Returns the big-endian 32-bit value at the pointer (MVI / title_intro chunk
; headers)
;-----------------------------------------------------------------------------
; C: src/front/title/ReadBE32.c
%ifdef CBUILD
%include "c/front/title/ReadBE32.inc"
%else
ReadBE32:
        push dword 0Ch
        call __CHK
        push ebx
        push edx
        movsx edx, byte [eax]
        inc eax
        movsx ebx, byte [eax]
        shl edx, 8
        inc eax
        add edx, ebx
        movsx ebx, byte [eax]
        shl edx, 8
        inc eax
        add edx, ebx
        movsx eax, byte [eax]
        shl edx, 8
        add eax, edx
        pop edx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; TitleScreen                                  1609F  95 PC, medium confidence
; The EA screen ("eascrn" scrn / msk1 / MASK) and the title ("title30", title
; music "mttitle" / "adtitle" by sound card, the "title.cmv" movie checked
; for the 'MVIf' tag, ended early by AnyInputPressed); returns nonzero when
; the player pressed something, 0 when it timed out; called from RunIntro
;-----------------------------------------------------------------------------
TitleScreen:
        push dword 378h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, 350h
        xor edx, edx
        mov dword [dword esp+032Ch], edx
        call ClearInputQueue
        call sub_B4BA8
        push byte 0
        call ClearScreen
        add esp, byte 4
        xor ecx, ecx
        mov ebx, str_Eascrn
        cmp byte [fileoncd+068h], 1
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
        add esp, byte 8
        mov dword [dword esp+0320h], eax
        push str_Pal4
        push eax
        call FindShape
        add esp, byte 8
        lea edx, [byte eax+010h]
        mov ebx, 300h
        mov eax, esp
        call memcpy_
        xor eax, eax
        mov dh, 3Fh
.3:
        mov dl, byte [esp+eax]
        cmp dl, 3Bh
        jge short .4
        mov bl, dl
        add bl, 5
        mov byte [esp+eax], bl
        jmp short .5
.4:
        mov byte [esp+eax], dh
.5:
        inc eax
        cmp eax, 300h
        jl short TitleScreen.3
        push str_Scrn2
        mov ebx, dword [dword esp+0324h]
        push ebx
        call FindShape
        add esp, byte 8
        push eax
        call sub_9121C
        add esp, byte 4
        push str_Msk1
        mov ecx, dword [dword esp+0324h]
        push ecx
        call FindShape
        mov ebp, eax
        add esp, byte 8
        push byte 20h
        push dword 9C51h
        push str_MASK
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [dword esp+033Ch], eax
        mov edi, eax
        mov esi, ebp
        movsd
        movsd
        movsd
        movsd
        movsb
        mov word [byte eax+04h], 0C8h
        mov word [byte eax+06h], 0C8h
        lea edx, [byte ebp+010h]
        add eax, byte 10h
        mov ebx, 9C40h
        call memcpy_
        mov esi, dword [dword esp+0320h]
        push esi
        call FreeMemBlock
        add esp, byte 4
        cmp byte [musicon], 0
        je short .8
        cmp dword [songdata], byte 0
        jne short .8
        mov ecx, str_Iff2
        mov ebx, str_Title30
        cmp byte [fileoncd+01DAh], 1
        jne short .6
        mov edx, dword [cddriveptr]
        jmp short .7
.6:
        xor edx, edx
.7:
        lea eax, [dword esp+0300h]
        call MakePath
        lea eax, [dword esp+0300h]
        call sub_8F98F
        mov dword [songdata], eax
        jmp short .13
.8:
        cmp dword [sounddev], byte 8
        jne short .10
        mov ecx, str_KMS
        mov ebx, str_Mttitle
        cmp byte [fileoncd+0104h], 1
        jne short .9
        mov edx, dword [cddriveptr]
        jmp short .12
.9:
        xor edx, edx
        jmp short .12
.10:
        mov ecx, str_KMS
        mov ebx, str_Adtitle
        cmp byte [fileoncd+0104h], 1
        jne short .11
        mov edx, dword [cddriveptr]
        jmp short .12
.11:
        xor edx, edx
.12:
        lea eax, [dword esp+0300h]
        call MakePath
        lea eax, [dword esp+0300h]
        call LoadSample
        mov dword [titlesample], eax
.13:
        mov ecx, str_Cmv
        mov ebx, str_Title
        cmp byte [fileoncd+024h], 1
        jne short .14
        mov edx, dword [cddriveptr]
        jmp short .15
.14:
        xor edx, edx
.15:
        lea eax, [dword esp+0300h]
        call MakePath
        push byte 20h
        push dword 2000h
        push dword 493E0h
        call sub_1B0F3
        add esp, byte 0Ch
        mov dword [dword esp+0340h], eax
        lea edx, [dword esp+0300h]
        push edx
        push eax
        call sub_1B1C2
        add esp, byte 8
        call sub_1AC25
        mov edi, eax
        push dword 96h
        call SetTickDeadline
        add esp, byte 4
.16:
        call TickDeadlinePassed
        test eax, eax
        jne short .17
        call sub_1B2A7
        jmp short TitleScreen.16
.17:
        mov dword [dword esp+0334h], 0Ah
        xor bl, bl
        mov byte [esp], bl
        mov byte [byte esp+01h], bl
        mov byte [byte esp+02h], bl
        cmp byte [musicon], 0
        je short .20
        cmp dword [songdata], byte 0
        je short .18
        mov edx, dword [musichandle]
        mov eax, dword [songdata]
        mov ecx, 4Ch
        mov ebx, 3
        call sub_8FB8E
.18:
        mov ebx, 10h
        mov edx, esp
        xor eax, eax
        call FadePalStep
        push byte 5Ah
        call SetTickDeadline
        add esp, byte 4
.19:
        call TickDeadlinePassed
        test eax, eax
        jne short .21
        call sub_1B2A7
        jmp short TitleScreen.19
.20:
        mov eax, dword [titlesample]
        call PlayDigiSample
        mov ebx, 10h
        mov edx, esp
        xor eax, eax
        call FadePalStep
.21:
        xor esi, esi
        call GetTicks
        mov dword [dword esp+0344h], eax
        mov dword [dword esp+034Ch], esi
        mov dword [dword esp+0338h], 1
        xor ebp, ebp
        call TicksSinceLastCall
        mov dword [dword esp+0348h], esi
.22:
        mov edx, dword [dword esp+0340h]
        push edx
        call sub_1B8AC
        mov edx, eax
        add esp, byte 4
        mov dword [dword esp+0324h], eax
        cmp eax, byte 0FFFFFFFFh
        jne short .23
        mov esi, eax
        jmp near .35
.23:
        test eax, eax
        je near .34
        call ReadBE32
        mov dword [dword esp+0330h], eax
        cmp eax, 4D564966h
        jb short .24
        jbe short .25
        cmp eax, 4D564968h
        je near .28
        jmp near .31
.24:
        cmp eax, 4D564965h
        je near .30
        jmp near .31
.25:
        mov eax, dword [dword esp+0334h]
        add dword [dword esp+034Ch], eax
        inc ebp
        mov eax, edi
        call sub_1B002
        mov dword [dword esp+0328h], eax
        call GetTicks
        sub eax, dword [dword esp+0344h]
        cmp eax, dword [dword esp+034Ch]
        jge short .26
        mov ecx, dword [dword esp+032Ch]
        push ecx
        call SetDrawBitmap
        add esp, byte 4
        mov eax, dword [dword esp+033Ch]
        push eax
        call sub_9121C
        add esp, byte 4
        push byte 0
        push byte 0
        mov edx, dword [dword esp+0330h]
        push edx
        call sub_9087C
        add esp, byte 0Ch
        call sub_B4BA8
        push byte 56h
        push byte 21h
        mov eax, dword [dword esp+0334h]
        mov ebx, dword [byte eax+02Ch]
        push ebx
        call sub_91284
        add esp, byte 0Ch
.26:
        cmp dword [dword esp+0338h], byte 1
        jne near .32
        cmp dword [dword esp+0348h], byte 0
        jne near .32
        cmp byte [musicon], 0
        je short .27
        cmp dword [nhlintrosaid], byte 0
        je short .27
        xor ebx, ebx
        mov dword [nhlintrosaid], ebx
        call PaNhlIntro
.27:
        xor ecx, ecx
        mov dword [dword esp+0338h], ecx
        call GetTicks
        mov dword [dword esp+0344h], eax
        jmp near .32
.28:
        mov eax, edi
        call sub_1AD16
        mov eax, edi
        call sub_1B092
        mov ebx, dword [dword esp+032Ch]
        test ebx, ebx
        jne short .29
        push ebx
        mov eax, edi
        call sub_1B0AD
        push eax
        mov eax, edi
        call sub_1B09F
        push eax
        call CreateBitmap
        add esp, byte 0Ch
        mov dword [dword esp+032Ch], eax
.29:
        mov ecx, dword [dword esp+032Ch]
        push ecx
        call SetDrawBitmap
        add esp, byte 4
        mov eax, dword [dword esp+033Ch]
        push eax
        call sub_9121C
        add esp, byte 4
        call sub_B4BA8
        push byte 56h
        push byte 21h
        mov eax, dword [dword esp+0334h]
        mov edx, dword [byte eax+02Ch]
        push edx
        call sub_91284
        add esp, byte 0Ch
        mov eax, edi
        call sub_1B0D7
        mov ecx, eax
        shl ecx, 2
        sub ecx, eax
        mov eax, edi
        call sub_1B0E5
        mov edx, eax
        mov eax, edi
        call sub_1B0C9
        mov ebx, eax
        shl eax, 2
        sub eax, ebx
        mov ebx, esp
        add eax, ebx
        mov ebx, ecx
        call memcpy_
        mov eax, esp
        push eax
        push dword 100h
        push byte 0
        call VgaSetPalette
        add esp, byte 0Ch
        mov eax, edi
        call sub_1B0BB
        mov ebx, eax
        mov eax, 64h
        mov edx, eax
        sar edx, 1Fh
        idiv ebx
        mov dword [dword esp+0334h], eax
        jmp short .32
.30:
        inc dword [dword esp+0348h]
        jmp short .32
.31:
        mov esi, 0FFFFFFFFh
.32:
        mov edx, dword [dword esp+0324h]
        push edx
        mov ebx, dword [dword esp+0344h]
        push ebx
        call sub_1B92E
        add esp, byte 8
        call sub_1B2A7
        cmp dword [dword esp+0330h], 4D564966h
        jne short .35
        call GetTicks
        sub eax, dword [dword esp+0344h]
        mov ebx, dword [dword esp+034Ch]
        cmp eax, ebx
        jge short .35
        mov edx, ebx
        sub edx, eax
        push edx
        call SetTickDeadline
        add esp, byte 4
.33:
        call TickDeadlinePassed
        test eax, eax
        jne short .35
        test esi, esi
        jne short .35
        cmp ebp, byte 23h
        jle short TitleScreen.33
        call AnyInputPressed
        mov esi, eax
        jmp short TitleScreen.33
.34:
        call sub_1B2A7
.35:
        test esi, esi
        jne short .36
        cmp ebp, byte 23h
        jle short .36
        call AnyInputPressed
        mov esi, eax
.36:
        test esi, esi
        jne short .37
        cmp dword [dword esp+0348h], byte 2
        jl near TitleScreen.22
.37:
        mov ebp, dword [dword esp+032Ch]
        test ebp, ebp
        je short .38
        push ebp
        call sub_9132C
        add esp, byte 4
.38:
        mov eax, edi
        call sub_1ACF1
        mov edx, dword [dword esp+0340h]
        push edx
        call sub_1B18B
        add esp, byte 4
        cmp byte [musicon], 0
        je short .39
        cmp dword [songdata], byte 0
        je short .39
        mov eax, dword [musichandle]
        mov ebx, 64h
        mov edx, 3
        call sub_8FCDF
.39:
        mov ebx, 10h
        mov edx, esp
        mov eax, 1
        call FadePalStep
        cmp byte [musicon], 0
        je short .41
        cmp dword [songdata], byte 0
        je short .41
.40:
        mov eax, dword [musicslot-3]
        sar eax, 18h
        mov edx, 3
        call SndQuery
        test eax, eax
        je short TitleScreen.40
        mov edi, dword [songdata]
        push edi
        call sub_8D2F0
        add esp, byte 4
        xor ebp, ebp
        mov dword [songdata], ebp
        jmp short .42
.41:
        call StopDigiSample
        mov eax, dword [titlesample]
        call FreeSample
.42:
        mov eax, dword [dword esp+033Ch]
        push eax
        call FreeMemBlock
        add esp, byte 4
        mov eax, esi
        add esp, 350h
        jmp near RunDemoGame_x
;-----------------------------------------------------------------------------
; RunIntro                                     1672A  95 PC, medium confidence
; Start-up sequence called once from main: the Pioneer logo screens
; ("pioneer1".."pioneer4", "bkgd", "fla%d" flashes, "pion"), the EA SPORTS
; opening ("eaopen", "easports"), then TitleScreen / RunDemoGame in turn
; until the player presses something; clears demomode on the way out
;-----------------------------------------------------------------------------
; C: src/front/title/RunDemoGame.c (RunIntro)
%ifdef CBUILD
%include "c/front/title/RunDemoGame.RunIntro.inc"
%else
RunIntro:
        push dword 674h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, 64Ch
        xor edx, edx
        mov dword [dword esp+0638h], edx
        cmp byte [musicon], 0
        je short .1
        mov eax, dword [speechbank]
        mov ebx, dword [dword eax+03B60h]
        push ebx
        call sub_8D2F0
        add esp, byte 4
.1:
        call ClearInputQueue
        call sub_B4BA8
        push byte 0
        call ClearScreen
        add esp, byte 4
        mov ecx, 300h
        xor edx, edx
        mov eax, blackpal
        call __STOSB
        push blackpal
        push dword 100h
        push byte 0
        call VgaSetPalette
        add esp, byte 0Ch
        xor ecx, ecx
        mov ebx, str_Pioneer1
        cmp byte [fileoncd+0127h], 1
        jne short .2
        mov edx, dword [cddriveptr]
        jmp short .3
.2:
        xor edx, edx
.3:
        lea eax, [dword esp+0600h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0604h]
        push eax
        call LoadBank
        mov esi, eax
        add esp, byte 8
        push str_Pl2
        push eax
        call FindShape
        add esp, byte 8
        lea edx, [byte eax+010h]
        mov ebx, 300h
        lea eax, [dword esp+0300h]
        call memcpy_
        push str_Pl1
        push esi
        call FindShape
        add esp, byte 8
        lea edx, [byte eax+010h]
        mov ebx, 300h
        mov eax, esp
        call memcpy_
        push str_Bkgd3
        push esi
        call FindShape
        add esp, byte 8
        push eax
        call sub_9121C
        add esp, byte 4
        push esi
        call FreeMemBlock
        add esp, byte 4
        xor ecx, ecx
        mov ebx, str_Pioneer2
        cmp byte [fileoncd+0128h], 1
        jne short .4
        mov edx, dword [cddriveptr]
        jmp short .5
.4:
        xor edx, edx
.5:
        lea eax, [dword esp+0600h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0604h]
        push eax
        call LoadBank
        add esp, byte 8
        mov ebp, eax
        cmp byte [musicon], 0
        je near .13
        cmp dword [songdata], byte 0
        jne near .13
        mov ecx, str_Iff2
        mov ebx, str_Pioneer4
        cmp byte [fileoncd+012Ch], 1
        jne short .6
        mov edx, dword [cddriveptr]
        jmp short .7
.6:
        xor edx, edx
.7:
        lea eax, [dword esp+0600h]
        call MakePath
        lea eax, [dword esp+0600h]
        call sub_8F98F
        mov dword [dword esp+0644h], eax
        mov ecx, str_Iff2
        mov ebx, str_Pioneer3
        cmp byte [fileoncd+012Bh], 1
        jne short .8
        mov edx, dword [cddriveptr]
        jmp short .9
.8:
        xor edx, edx
.9:
        lea eax, [dword esp+0600h]
        call MakePath
        lea eax, [dword esp+0600h]
        call sub_8F98F
        mov dword [dword esp+0648h], eax
        mov ecx, str_Iff2
        mov ebx, str_Pioneer2
        cmp byte [fileoncd+012Ah], 1
        jne short .10
        mov edx, dword [cddriveptr]
        jmp short .11
.10:
        xor edx, edx
.11:
        lea eax, [dword esp+0600h]
        call MakePath
        lea eax, [dword esp+0600h]
        call sub_8F98F
        mov dword [dword esp+0640h], eax
        mov dword [songdata], eax
        test eax, eax
        je short .12
        mov edx, dword [musichandle]
        mov ecx, 7Fh
        mov ebx, 1
        call sub_8FB8E
.12:
        push dword 104h
        call SetTickDeadline
        add esp, byte 4
        call WaitTickDeadline
        mov dword [dword esp+063Ch], 50h
        jmp short .14
.13:
        mov dword [dword esp+063Ch], 0C8h
.14:
        cmp byte [musicon], 0
        je short .15
        mov eax, dword [songdata]
        test eax, eax
        je short .15
        mov edx, dword [musichandle]
        mov ecx, 64h
        xor ebx, ebx
        call sub_8FB8E
.15:
        mov ebx, 5Ah
        mov edx, esp
        xor eax, eax
        call FadePalStep
        mov edi, 1
.16:
        test edi, edi
        je short .20
        xor edi, edi
        xor esi, esi
.17:
        mov al, byte [esp+esi]
        mov bl, byte [dword esp+esi+0300h]
        cmp al, bl
        jge short .18
        mov edi, 1
        mov ch, al
        inc ch
        mov byte [esp+esi], ch
        jmp short .19
.18:
        jle short .19
        mov edi, 1
        mov cl, al
        dec cl
        mov byte [esp+esi], cl
.19:
        inc esi
        cmp esi, 300h
        jl short RunIntro.17
        push byte 2
        call SetTickDeadline
        add esp, byte 4
        call WaitTickDeadline
        test edi, edi
        je short RunIntro.16
        mov eax, esp
        push eax
        push dword 100h
        push byte 0
        call VgaSetPalette
        add esp, byte 0Ch
        jmp short RunIntro.16
.20:
        mov edx, dword [dword esp+063Ch]
        push edx
        call SetTickDeadline
        add esp, byte 4
        call WaitTickDeadline
        mov esi, 1
.21:
        push esi
        push str_FlaD
        lea eax, [dword esp+0608h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        lea eax, [dword esp+0600h]
        push eax
        push ebp
        call FindShape
        add esp, byte 8
        mov dword [dword esp+esi*4+0620h], eax
        inc esi
        cmp esi, byte 5
        jl short RunIntro.21
        push str_Pion
        push ebp
        call FindShape
        add esp, byte 8
        mov dword [dword esp+0620h], eax
        mov edi, 1
.22:
        test edi, edi
        je short .25
        xor edi, edi
        xor esi, esi
.23:
        mov al, byte [esp+esi]
        cmp al, byte [dword esp+esi+0300h]
        jge short .24
        mov edi, 1
        mov dl, al
        inc dl
        mov byte [esp+esi], dl
.24:
        inc esi
        cmp esi, 270h
        jl short RunIntro.23
        push byte 5
        call SetTickDeadline
        add esp, byte 4
        call WaitTickDeadline
        test edi, edi
        je short RunIntro.22
        mov eax, esp
        push eax
        push dword 100h
        push byte 0
        call VgaSetPalette
        add esp, byte 0Ch
        jmp short RunIntro.22
.25:
        mov ebx, 300h
        mov edx, 3Fh
        mov eax, esp
        call memset_
        push str_Pio
        push ebp
        call FindShape
        add esp, byte 8
        lea edx, [byte eax+010h]
        mov ebx, 300h
        lea eax, [dword esp+0300h]
        call memcpy_
        push byte 50h
        call SetTickDeadline
        add esp, byte 4
        call WaitTickDeadline
        cmp byte [musicon], 0
        je short .26
        cmp dword [dword esp+0648h], byte 0
        je short .26
        mov edx, dword [musichandle]
        mov ecx, 7Fh
        mov ebx, 2
        mov eax, dword [dword esp+0648h]
        call sub_8FB8E
.26:
        mov esi, 1
.27:
        mov ecx, dword [dword esp+esi*4+0620h]
        push ecx
        call DrawShape
        add esp, byte 4
        inc esi
        cmp esi, byte 5
        jl short RunIntro.27
        mov eax, esp
        push eax
        push dword 100h
        push byte 0
        call VgaSetPalette
        add esp, byte 0Ch
        mov esi, dword [dword esp+0620h]
        push esi
        call sub_9121C
        add esp, byte 4
        push ebp
        call FreeMemBlock
        add esp, byte 4
        mov edi, 1
.28:
        test edi, edi
        je short .31
        xor edi, edi
        xor esi, esi
.29:
        mov al, byte [esp+esi]
        cmp al, byte [dword esp+esi+0300h]
        jle short .30
        mov edi, 1
        dec al
        mov byte [esp+esi], al
.30:
        inc esi
        cmp esi, 300h
        jl short RunIntro.29
        push byte 5
        call SetTickDeadline
        add esp, byte 4
        call WaitTickDeadline
        test edi, edi
        je short RunIntro.28
        mov eax, esp
        push eax
        push dword 100h
        push byte 0
        call VgaSetPalette
        add esp, byte 0Ch
        jmp short RunIntro.28
.31:
        push byte 28h
        call SetTickDeadline
        add esp, byte 4
        call WaitTickDeadline
        cmp byte [musicon], 0
        je short .32
        mov edi, dword [dword esp+0644h]
        test edi, edi
        je short .32
        mov edx, dword [musichandle]
        mov ecx, 7Fh
        mov ebx, 3
        mov eax, edi
        call sub_8FB8E
.32:
        mov esi, 0E0h
.33:
        cmp esi, 0E0h
        jle short .34
        lea edx, [byte esi-01h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        xor bl, bl
        mov byte [esp+eax], bl
        mov byte [byte esp+eax+01h], bl
        mov byte [byte esp+eax+02h], bl
.34:
        mov eax, esi
        shl eax, 2
        sub eax, esi
        mov ch, 3Fh
        mov byte [esp+eax], ch
        mov byte [byte esp+eax+01h], ch
        mov byte [byte esp+eax+02h], ch
        push byte 2
        call SetTickDeadline
        add esp, byte 4
        call WaitTickDeadline
        mov eax, esp
        push eax
        push dword 100h
        push byte 0
        call VgaSetPalette
        add esp, byte 0Ch
        inc esi
        cmp esi, 0F0h
        jl short RunIntro.33
        push dword 0C8h
        call SetTickDeadline
        add esp, byte 4
        call WaitTickDeadline
        cmp byte [musicon], 0
        je short .35
        mov eax, dword [musichandle]
        mov ebx, 64h
        xor edx, edx
        call sub_8FCDF
        mov eax, dword [musichandle]
        mov ebx, 64h
        mov edx, 1
        call sub_8FCDF
        mov eax, dword [musichandle]
        mov ebx, 64h
        mov edx, 2
        call sub_8FCDF
        mov eax, dword [musichandle]
        mov ebx, 64h
        mov edx, 3
        call sub_8FCDF
        jmp short .36
.35:
        cmp dword [dword esp+0638h], byte 0
        jne short .36
        mov eax, 78h
        call WaitClickTimeout
.36:
        cmp byte [musicon], 0
        je near .43
.37:
        mov eax, dword [musicslot-3]
        sar eax, 18h
        xor edx, edx
        call SndQuery
        test eax, eax
        je short RunIntro.37
.38:
        mov eax, dword [musicslot-3]
        sar eax, 18h
        mov edx, 1
        call SndQuery
        test eax, eax
        je short RunIntro.38
.39:
        mov eax, dword [musicslot-3]
        sar eax, 18h
        mov edx, 2
        call SndQuery
        test eax, eax
        je short RunIntro.39
.40:
        mov eax, dword [musicslot-3]
        sar eax, 18h
        mov edx, 3
        call SndQuery
        test eax, eax
        je short RunIntro.40
        xor eax, eax
        mov dword [songdata], eax
        mov edx, dword [dword esp+0640h]
        test edx, edx
        je short .41
        push edx
        call sub_8D2F0
        add esp, byte 4
.41:
        mov ecx, dword [dword esp+0648h]
        test ecx, ecx
        je short .42
        push ecx
        call sub_8D2F0
        add esp, byte 4
.42:
        mov edi, dword [dword esp+0644h]
        test edi, edi
        je short .43
        push edi
        call sub_8D2F0
        add esp, byte 4
.43:
        cmp byte [musicon], 0
        je short .44
        mov dword [cursndbank], 20h
        mov eax, dword [dword_C4CFC]
        call InitSpeechSlots
        xor edx, edx
        mov dword [cursndbank], edx
.44:
        call PaOpenBank
        mov ebx, 10h
        lea edx, [dword esp+0300h]
        mov eax, 1
        call FadePalStep
        lea eax, [dword esp+0634h]
        call _dos_gettime_
        xor eax, eax
        mov al, byte [dword esp+0637h]
        call srand_
.45:
        xor ecx, ecx
        mov ebx, str_Eaopen
        cmp byte [fileoncd+067h], 1
        jne short .46
        mov edx, dword [cddriveptr]
        jmp short .47
.46:
        xor edx, edx
.47:
        lea eax, [dword esp+0600h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0604h]
        push eax
        call LoadBank
        mov esi, eax
        add esp, byte 8
        push str_Pal4
        push eax
        call FindShape
        add esp, byte 8
        lea edx, [byte eax+010h]
        mov ebx, 300h
        mov eax, esp
        call memcpy_
        push str_Scrn2
        push esi
        call FindShape
        add esp, byte 8
        push eax
        call sub_912C8
        add esp, byte 4
        push esi
        call FreeMemBlock
        add esp, byte 4
        cmp byte [musicon], 0
        je short .50
        cmp dword [songdata], byte 0
        jne short .50
        mov ecx, str_Iff2
        mov ebx, str_Easports
        cmp byte [fileoncd+01DCh], 1
        jne short .48
        mov edx, dword [cddriveptr]
        jmp short .49
.48:
        xor edx, edx
.49:
        lea eax, [dword esp+0600h]
        call MakePath
        lea eax, [dword esp+0600h]
        call sub_8F98F
        mov dword [songdata], eax
        test eax, eax
        je short .50
        mov edx, dword [musichandle]
        mov ecx, 4Ch
        mov ebx, 3
        call sub_8FB8E
.50:
        mov ebx, 10h
        mov edx, esp
        xor eax, eax
        call FadePalStep
        push dword 0C8h
        call SetTickDeadline
        add esp, byte 4
        call WaitTickDeadline
        cmp byte [musicon], 0
        je short .52
        cmp dword [songdata], byte 0
        je short .52
.51:
        mov eax, dword [musicslot-3]
        sar eax, 18h
        mov edx, 3
        call SndQuery
        test eax, eax
        je short RunIntro.51
        mov esi, dword [songdata]
        push esi
        call sub_8D2F0
        add esp, byte 4
        xor edi, edi
        mov dword [songdata], edi
.52:
        mov ebx, 10h
        mov edx, esp
        mov eax, 1
        call FadePalStep
        call sub_B4BA8
        push byte 0
        call ClearScreen
        add esp, byte 4
        call TitleScreen
        test eax, eax
        jne short .53
        call RunDemoGame
        test eax, eax
        je near RunIntro.45
.53:
        call sub_B4BA8
        push byte 0
        call ClearScreen
        add esp, byte 4
        call PaOpenBank
        xor ebp, ebp
        mov dword [demoflag], ebp
        mov dword [demomode], ebp
        add esp, 64Ch
        jmp near RunDemoGame_x
%endif ; C
;-----------------------------------------------------------------------------
; ShowCredits                                  16F9A  95 PC, medium confidence
; Credits screen ("backwin", "credits" art, "rockditi" song, scrolling text
; lines drawn by RenderTextLine); called from main at exit and from
; frontend_desk
;-----------------------------------------------------------------------------
ShowCredits:
        push dword 394h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, 36Ch
        call TextGridFree
        call PaOpenBank
        lea eax, [dword esp+0300h]
        push eax
        call TextSaveState
        add esp, byte 4
        mov edx, dword [mainfont]
        push edx
        call TextSetFont
        add esp, byte 4
        xor edx, edx
        mov eax, 7Fh
        call SetTextColors
        push byte 0
        push dword 19337h
        push str_Backwin
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [dword esp+0360h], eax
        xor ecx, ecx
        mov ebx, str_Credits
        cmp byte [fileoncd+021Dh], 1
        jne short .1
        mov edx, dword [cddriveptr]
        jmp short .2
.1:
        xor edx, edx
.2:
        lea eax, [dword esp+0340h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0344h]
        push eax
        call LoadBank
        mov ebp, eax
        add esp, byte 8
        push str_Pal4
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
        mov eax, blackpal
        call memcpy_
        push str_Bkgd3
        push ebp
        call FindShape
        mov edx, eax
        add esp, byte 8
        mov esi, dword [pointerspr]
        mov edi, dword [dword esp+0360h]
        movsd
        movsd
        movsd
        movsd
        movsb
        mov eax, dword [dword esp+0360h]
        mov word [byte eax+04h], 135h
        mov word [byte eax+06h], 14Eh
        call FadeOutPalCycle
        push edx
        call DrawBitmap
        add esp, byte 4
        push ebp
        call FreeMemBlock
        add esp, byte 4
        push byte 3Fh
        push dword 14Ah
        mov ebx, dword [dword esp+0368h]
        push ebx
        call GrabBlock
        add esp, byte 0Ch
        cmp byte [musicon], 0
        je short .5
        cmp dword [songdata], byte 0
        jne short .5
        mov ecx, str_Iff2
        mov ebx, str_Credits
        cmp byte [fileoncd+01E1h], 1
        jne short .3
        mov edx, dword [cddriveptr]
        jmp short .4
.3:
        xor edx, edx
.4:
        lea eax, [dword esp+0340h]
        call MakePath
        lea eax, [dword esp+0340h]
        call sub_8F98F
        mov dword [songdata], eax
        test eax, eax
        je near .12
        mov edx, dword [musichandle]
        mov ecx, 4Ch
        mov ebx, 3
        call sub_8FB8E
        jmp near .12
.5:
        cmp dword [sounddev], byte 8
        jne short .7
        mov ecx, str_KMS
        mov ebx, str_Adtitle
        cmp byte [fileoncd+0104h], 1
        jne short .6
        mov edx, dword [cddriveptr]
        jmp short .9
.6:
        xor edx, edx
        jmp short .9
.7:
        mov ecx, str_KMS
        mov ebx, str_Adtitle
        cmp byte [fileoncd+0104h], 1
        jne short .8
        mov edx, dword [cddriveptr]
        jmp short .9
.8:
        xor edx, edx
.9:
        lea eax, [dword esp+0340h]
        call MakePath
        lea eax, [dword esp+0340h]
        call LoadSample
        mov dword [dword esp+0354h], eax
        mov ecx, str_KMS
        mov ebx, str_Rockditi
        cmp byte [fileoncd+0161h], 1
        jne short .10
        mov edx, dword [cddriveptr]
        jmp short .11
.10:
        xor edx, edx
.11:
        lea eax, [dword esp+0340h]
        call MakePath
        lea eax, [dword esp+0340h]
        call LoadSample
        mov dword [dword esp+0350h], eax
        mov eax, dword [dword esp+0354h]
        call PlayDigiSample
.12:
        mov ebx, 10h
        mov edx, esp
        xor eax, eax
        call FadePalStep
        call PaGoodnight
        xor edi, edi
        mov dword [dword esp+035Ch], edi
        mov dword [dword esp+0364h], edi
.13:
        cmp dword [dword esp+0364h], byte 7
        jne short .14
        mov edx, dword [kaufmfont]
        push edx
        call TextSetFont
        add esp, byte 4
.14:
        mov eax, dword [dword esp+0364h]
        mov eax, dword [nosplit eax*4+creditpages]
        mov dword [dword esp+0368h], eax
        call ClearInputQueue
        cmp dword [dword esp+0364h], byte 0
        je short .15
        mov eax, 62h
        call WaitClickTimeout
        mov dword [dword esp+035Ch], eax
.15:
        mov ecx, dword [dword esp+035Ch]
        test ecx, ecx
        jne near .23
        mov esi, dword [dword esp+0368h]
        cmp esi, unk_C638C
        je near .22
        mov eax, dword [byte esi+05h]
        cmp byte [eax], 0
        je near .18
        cmp byte [fileoncd+021Eh], 1
        jne short .16
        mov edx, dword [cddriveptr]
        jmp short .17
.16:
        xor edx, edx
.17:
        mov ebx, eax
        lea eax, [dword esp+0340h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0344h]
        push eax
        call LoadBank
        mov esi, eax
        add esp, byte 8
        push str_Shp0
        push eax
        call FindShape
        mov edi, eax
        add esp, byte 8
        push byte 3Fh
        push dword 14Ah
        mov ebp, dword [dword esp+0368h]
        push ebp
        call PutBlock
        add esp, byte 0Ch
        call rand_
        mov edx, eax
        sar edx, 1Fh
        mov ecx, 8
        idiv ecx
        add edx, byte 6Ah
        push edx
        call rand_
        mov edx, eax
        sar edx, 1Fh
        idiv ecx
        add edx, 85h
        push edx
        push edi
        call DrawArt
        add esp, byte 0Ch
        push esi
        call FreeMemBlock
        add esp, byte 4
        jmp short .19
.18:
        push byte 3Fh
        push dword 14Ah
        mov edi, dword [dword esp+0368h]
        push edi
        call PutBlock
        add esp, byte 0Ch
.19:
        mov eax, dword [dword esp+0368h]
        mov eax, dword [byte eax+01h]
        mov dword [dword esp+0358h], eax
        xor eax, eax
        mov al, byte [byte_D42C3]
        mov edx, dword [dword esp+0368h]
        movsx edx, byte [edx]
        imul eax, edx
        sar eax, 1
        mov edi, 0DAh
        sub edi, eax
        xor esi, esi
        jmp short .21
.20:
        mov ebp, esi
        shl ebp, 2
        add ebp, dword [dword esp+0368h]
        mov ebp, dword [byte ebp+09h]
        push ebp
        call fputchar
        add esp, byte 4
        sar eax, 1
        mov edx, 1EAh
        sub edx, eax
        mov eax, edx
        mov ebx, ebp
        mov edx, edi
        call RenderTextLine
        xor eax, eax
        mov al, byte [byte_D42C3]
        add edi, eax
        inc esi
.21:
        mov eax, dword [dword esp+0368h]
        movsx eax, byte [eax]
        cmp esi, eax
        jl short ShowCredits.20
        call ClearInputQueue
        mov eax, dword [dword esp+0358h]
        call WaitClickTimeout
        test eax, eax
        jne short .23
.22:
        mov edx, dword [dword esp+0364h]
        inc edx
        mov dword [dword esp+0364h], edx
        cmp edx, byte 1Dh
        jl near ShowCredits.13
.23:
        push byte 3Fh
        push dword 14Ah
        mov ecx, dword [dword esp+0368h]
        push ecx
        call PutBlock
        add esp, byte 0Ch
        cmp byte [musicon], 0
        je short .24
        cmp dword [songdata], byte 0
        je short .24
        mov eax, dword [musichandle]
        mov ebx, 64h
        mov edx, 3
        call sub_8FCDF
.24:
        call SpeechStopQueue
        mov ebx, 10h
        mov edx, esp
        mov eax, 1
        call FadePalStep
        cmp byte [musicon], 0
        je short .26
        cmp dword [songdata], byte 0
        je short .26
.25:
        mov eax, dword [musicslot-3]
        sar eax, 18h
        mov edx, 3
        call SndQuery
        test eax, eax
        je short ShowCredits.25
        mov ebp, dword [songdata]
        push ebp
        call sub_8D2F0
        add esp, byte 4
        xor eax, eax
        mov dword [songdata], eax
        jmp short .27
.26:
        call StopDigiSample
        mov eax, dword [dword esp+0354h]
        call FreeSample
        mov eax, dword [dword esp+0350h]
        call FreeSample
.27:
        lea eax, [dword esp+0300h]
        push eax
        call TextRestoreState
        add esp, byte 4
        mov edx, dword [dword esp+0360h]
        push edx
        call FreeMemBlock
        add esp, byte 4
        call sub_B4BA8
        push byte 0
        call ClearScreen
        add esp, byte 4
        add esp, 36Ch
        jmp near RunDemoGame_x
;-----------------------------------------------------------------------------
; SetTextColors                                                   174C2  95 PC
; (colour, shadow colour): sets textcolor / textshadow used by the Print*
; text routines
;-----------------------------------------------------------------------------
; C: src/front/title/SetTextColors.c
%ifdef CBUILD
%include "c/front/title/SetTextColors.inc"
%else
SetTextColors:
        push dword 4
        call __CHK
        mov dword [textcolor], eax
        mov dword [textshadow], edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; RenderTextLine                               174D8  95 PC, medium confidence
; (?, y, text): draws the text (PrintShadowText) into a temporary bitmap
; sized to its width (rounded up to 40h) and the font height, blits it with
; DrawArt and frees it; ShowCredits
;-----------------------------------------------------------------------------
; C: src/front/title/RenderTextLine.c
%ifdef CBUILD
%include "c/front/title/RenderTextLine.inc"
%else
RenderTextLine:
        push dword 84h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 60h
        push eax
        mov ebp, edx
        mov edi, ebx
        push ebx
        call fputchar
        add esp, byte 4
        and eax, 0FFC0h
        lea esi, [byte eax+040h]
        xor eax, eax
        mov al, byte [byte_D42C3]
        inc eax
        push byte 0
        push eax
        push esi
        call CreateBitmap
        mov esi, eax
        add esp, byte 0Ch
        lea eax, [byte esp+04h]
        push eax
        call sub_B3A88
        add esp, byte 4
        push esi
        call SetDrawBitmap
        add esp, byte 4
        push dword 0FFh
        call ClearScreen
        add esp, byte 4
        mov ebx, edi
        xor edx, edx
        xor eax, eax
        call PrintShadowText
        lea eax, [byte esp+04h]
        push eax
        call sub_B3AA1
        add esp, byte 4
        push ebp
        mov edx, dword [byte esp+04h]
        push edx
        mov ebx, dword [byte esi+02Ch]
        push ebx
        call DrawArt
        add esp, byte 0Ch
        push esi
        call sub_9132C
        add esp, byte 4
        add esp, byte 64h
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; PrintCenteredText                                               17573  95 PC
; (y, text): PrintShadowText centred on the 640-pixel screen (fputchar is the
; text width), also logged with TextGridPut
;-----------------------------------------------------------------------------
; C: src/front/title/PrintCenteredText.c
%ifdef CBUILD
%include "c/front/title/PrintCenteredText.inc"
%else
PrintCenteredText:
        push dword 24h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        mov ebp, eax
        mov esi, edx
        push edx
        call fputchar
        add esp, byte 4
        mov edx, 280h
        sub edx, eax
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov edi, eax
        mov eax, dword [textshadow]
        mov dword [fontcolor], eax
        lea eax, [byte ebp+01h]
        push eax
        lea eax, [byte edi+01h]
        push eax
        push esi
        call PrintString
        add esp, byte 0Ch
        mov eax, dword [textcolor]
        mov dword [fontcolor], eax
        push ebp
        push edi
        push esi
        call PrintString
        add esp, byte 0Ch
        mov ebx, esi
        mov edx, ebp
        mov eax, edi
        call TextGridPut
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; PrintShadowText                                                 175E2  95 PC
; (x, y, text): draws the text at +1,+1 in textshadow, then at x,y in
; textcolor (PrintString), and logs it with TextGridPut
;-----------------------------------------------------------------------------
; C: src/front/title/PrintShadowText.c
%ifdef CBUILD
%include "c/front/title/PrintShadowText.inc"
%else
PrintShadowText:
        push dword 20h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        mov edi, eax
        mov ebp, edx
        mov esi, ebx
        mov eax, dword [textshadow]
        mov dword [fontcolor], eax
        lea eax, [byte edx+01h]
        push eax
        lea eax, [byte edi+01h]
        push eax
        push ebx
        call PrintString
        add esp, byte 0Ch
        mov eax, dword [textcolor]
        mov dword [fontcolor], eax
        push ebp
        push edi
        push esi
        call PrintString
        add esp, byte 0Ch
        mov ebx, esi
        mov edx, ebp
        mov eax, edi
        call TextGridPut
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; PrintOutlinedText                                               17636  95 PC
; (x, y, text): draws the text 4 times in textshadow at the outline offsets
; (textoutlinedx / textoutlinedy), then in textcolor; TextGridPut
;-----------------------------------------------------------------------------
; C: src/front/title/PrintOutlinedText.c
%ifdef CBUILD
%include "c/front/title/PrintOutlinedText.inc"
%else
PrintOutlinedText:
        push dword 24h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov edi, eax
        mov ebp, edx
        mov dword [esp], ebx
        mov eax, dword [textshadow]
        mov dword [fontcolor], eax
        xor esi, esi
.1:
        mov edx, dword [nosplit esi*4+textoutlinedy]
        add edx, ebp
        push edx
        mov eax, dword [nosplit esi*4+textoutlinedx]
        add eax, edi
        push eax
        mov edx, dword [byte esp+08h]
        push edx
        call PrintString
        add esp, byte 0Ch
        inc esi
        cmp esi, byte 4
        jl short PrintOutlinedText.1
        mov eax, dword [textcolor]
        mov dword [fontcolor], eax
        push ebp
        push edi
        mov ebx, dword [byte esp+08h]
        push ebx
        call PrintString
        add esp, byte 0Ch
        mov ebx, dword [esp]
        mov edx, ebp
        mov eax, edi
        call TextGridPut
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; PrintFmt1                                                       176AE  95 PC
; (x, y, fmt, a): sprintf then PrintShadowText
;-----------------------------------------------------------------------------
; C: src/front/title/PrintFmt1.c
%ifdef CBUILD
%include "c/front/title/PrintFmt1.inc"
%else
PrintFmt1:
        push dword 68h
        call __CHK
        push esi
        sub esp, byte 54h
        mov esi, eax
        push ecx
        push ebx
        lea ebx, [byte esp+08h]
        push ebx
        call sprintf_
        add esp, byte 0Ch
        mov ebx, esp
        mov eax, esi
        call PrintShadowText
        add esp, byte 54h
        pop esi
        ret
;-----------------------------------------------------------------------------
; PrintFmt2                                                       176DB  95 PC
; (x, y, fmt, a, b): sprintf then PrintShadowText
;-----------------------------------------------------------------------------
PrintFmt2:
        push dword 70h
        call __CHK
        push esi
        push edi
        sub esp, byte 54h
        mov esi, eax
        mov edi, dword [byte esp+060h]
        push edi
        push ecx
        push ebx
        lea ebx, [byte esp+0Ch]
        push ebx
        call sprintf_
        add esp, byte 10h
        mov ebx, esp
        mov eax, esi
        call PrintShadowText
        add esp, byte 54h
        pop edi
        pop esi
        ret 4
%endif ; C
;-----------------------------------------------------------------------------
; TextGridOpen                                 17711  95 PC, medium confidence
; Allocates (once) and clears to spaces the 100 x 36 character copy of the
; screen text (textgrid) and enables logging (textgridon)
;-----------------------------------------------------------------------------
; C: src/front/title/TextGridOpen.c
%ifdef CBUILD
%include "c/front/title/TextGridOpen.inc"
%else
TextGridOpen:
        push dword 0Ch
        call __CHK
        push ebx
        push edx
        cmp dword [textgrid], byte 0
        jne short .1
        mov eax, 0E74h
        call _nmalloc_
        mov dword [textgrid], eax
.1:
        mov dword [textgridon], 1
        mov eax, dword [textgrid]
        mov ebx, 0E10h
        mov edx, 20h
        call memset_
        pop edx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; TextGridFree                                 17756  95 PC, medium confidence
; Frees textgrid
;-----------------------------------------------------------------------------
; C: src/front/title/TextGridFree.c
%ifdef CBUILD
%include "c/front/title/TextGridFree.inc"
%else
TextGridFree:
        push dword 0Ch
        call __CHK
        push ebx
        push edx
        mov edx, dword [textgrid]
        test edx, edx
        je short .1
        mov eax, edx
        call _nfree_
.1:
        xor ebx, ebx
        mov dword [textgrid], ebx
        pop edx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; TextGridOff                                  1777E  95 PC, medium confidence
; Textgridon = 0
;-----------------------------------------------------------------------------
; C: src/front/title/TextGridOff.c
%ifdef CBUILD
%include "c/front/title/TextGridOff.inc"
%else
TextGridOff:
        push dword 8
        call __CHK
        push edx
        xor edx, edx
        mov dword [textgridon], edx
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; TextGridPut                                  17793  95 PC, medium confidence
; (x, y, text): when textgridon, copies the text into textgrid at column
; x*100/640, row y*36/480
;-----------------------------------------------------------------------------
; C: src/front/title/TextGridPut.c
%ifdef CBUILD
%include "c/front/title/TextGridPut.inc"
%else
TextGridPut:
        push dword 0Ch
        call __CHK
        push ecx
        push esi
        mov esi, edx
        mov ecx, ebx
        cmp dword [textgrid], byte 0
        je short .x
        cmp dword [textgridon], byte 1
        jne short .x
        mov edx, eax
        shl eax, 2
        sub eax, edx
        shl eax, 3
        add edx, eax
        shl edx, 2
        mov ebx, 280h
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov ebx, eax
        mov edx, esi
        shl edx, 3
        add edx, esi
        shl edx, 2
        mov esi, 1E0h
        mov eax, edx
        sar edx, 1Fh
        idiv esi
        mov esi, dword [textgrid]
        mov edx, eax
        shl eax, 2
        sub eax, edx
        shl eax, 3
        add eax, edx
        shl eax, 2
        add ebx, eax
        add esi, ebx
        mov eax, ecx
        call strlen_
        mov ebx, eax
        mov edx, ecx
        mov eax, esi
        call memcpy_
.x:
        pop esi
        pop ecx
        ret
%endif ; C
