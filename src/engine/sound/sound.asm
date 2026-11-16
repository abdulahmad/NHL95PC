; Crowd noise and digitized samples during play, and the calls into the
; announcer.
bits 32
%include "hockey.inc"
section s_59493 progbits alloc exec nowrite align=1
extern __CHK, crowddriver, crowdlevel, crowdsmooth, crowdvol7, crowdvol8, digihandle, cursndbank
extern oneminsaid, dword_D2427, crowdsamples, dword_ED7A4, gameopts, gmode, lastsfx, leaguesetimg
extern MusicChanReset, musicon, OpenAnnouncerBank, PreloadAnnouncerClips, rand_, randomd0, rockteamcues, SayElseNhl
extern SayGoal, SayGoodnight, SayHighlightIntro, SayLineups, SayNhlIntro, SayOneMinuteLeft, SayPenalty, SayPenaltyShot
extern SayPlayerNumber, SayPlayoffResult, SayPlayoffTonight, SayScoringPeriod, SayTonightIntro, SetTickDeadline, sounddev, SpeechBusy
extern OpenArtArchive, LoadFileAllocQuiet, PlaySong, PlayPatchFull, StopSongId, ReleaseSong, SongFinished, MidiProgramChange
extern MidiSetVolume, MidiPitchBend, MidiNoteOn, MidiNoteOff, teamabbrevs, WaitTickDeadline
global SndLoadFile, sndcb_addesp8_x, SndLoadFile2, Crowd_Noise, CrowdNoiseOff, CrowdFadeOut, CrowdNoiseReset, sfx
global FreeDigiSample, StopDigiSample, PlayDigiSample, WaitDigiSample, PlayCrowdSample, PlayCrowdSample_ret, PaOneMinuteLeft, PaSpeechBusy
global PaGoal, PaPlayerNumber, PaPenalty, PaPenaltyShot, PaTonightIntro, PaTonightIntro_ret, PaScoringPeriod, PaNhlIntro
global PaGoodnight, PaLineups, PaElseNhl, PaHighlightIntro, PaPlayoffResult, PaPlayoffTonight, PaOpenBank, PaPreloadClips
;-----------------------------------------------------------------------------
; SndLoadFile                                     59493  95 PC, low confidence
; Sound-library file load callback: OpenArtArchive with the load flags cursndbank
; (20h, set by the sound config)
;-----------------------------------------------------------------------------
; C: src/engine/sound/SndLoadFile.c
%ifdef CBUILD
%include "c/engine/sound/SndLoadFile.inc"
%else
SndLoadFile:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        mov ebx, dword [cursndbank]
        push ebx
        push edx
        call OpenArtArchive
sndcb_addesp8_x:
        add esp, byte 8
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; SndLoadFile2                                    594B2  95 PC, low confidence
; Second sound-library load callback: LoadFileAllocQuiet with the load flags
; cursndbank
;-----------------------------------------------------------------------------
SndLoadFile2:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        mov ebx, dword [cursndbank]
        push ebx
        push edx
        call LoadFileAllocQuiet
        jmp short sndcb_addesp8_x
%endif ; C
;-----------------------------------------------------------------------------
; Crowd_Noise                        594CD  94G crowd94.asm, medium confidence
; Role match: the crowd noise each frame (PC MIDI, 94G PSG)
;-----------------------------------------------------------------------------
; C: src/engine/sound/Crowd_Noise.c
%ifdef CBUILD
%include "c/engine/sound/Crowd_Noise.inc"
%else
Crowd_Noise:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        test byte [gameopts], 80h
        je near .x
        test byte [sounddev], 2Ah
        je near .x
        cwde
        mov esi, eax
        shl esi, 4
        sub esi, eax
        add esi, esi
        mov ecx, dword [crowdlevel-2]
        sar ecx, 10h
        sub ecx, dword [crowdsmooth]
        test ecx, ecx
        jge short .1
        mov eax, ecx
        neg eax
        jmp short .2
.1:
        mov eax, ecx
.2:
        cmp eax, esi
        jle short .4
        test ecx, ecx
        jge short .3
        neg esi
.3:
        add dword [crowdsmooth], esi
        jmp short .5
.4:
        mov eax, dword [crowdlevel-2]
        sar eax, 10h
        mov dword [crowdsmooth], eax
.5:
        mov ecx, dword [crowdsmooth]
        cmp ecx, 200h
        jge short .6
        xor ecx, ecx
        jmp short .8
.6:
        cmp ecx, 390h
        jge short .7
        lea edx, [dword ecx-0200h]
        mov ebx, 0Ah
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov ecx, eax
        test byte [sounddev], 8
        je short .8
        lea ecx, [byte eax+020h]
        jmp short .8
.7:
        lea eax, [dword ecx-0390h]
        sar eax, 2
        lea ecx, [byte eax+028h]
        test byte [sounddev], 8
        je short .8
        add ecx, byte 20h
.8:
        cmp ecx, byte 7Fh
        jle short .9
        mov ecx, 7Fh
.9:
        mov ebx, 0Ch
        mov eax, dword [crowdsmooth]
        mov edx, eax
        sar edx, 1Fh
        idiv ebx
        lea esi, [byte eax+0Ah]
        test byte [sounddev], 8
        je short .10
        add esi, byte 32h
.10:
        cmp esi, byte 7Fh
        jle short .11
        mov esi, 7Fh
.11:
        cmp esi, byte 0Ah
        jge short .12
        mov esi, 0Ah
.12:
        cmp dword [crowdvol8], byte 0
        jle short .13
        test ecx, ecx
        jne short .13
        xor eax, eax
        mov al, byte [crowddriver]
        xor ebx, ebx
        mov edx, 8
        call MidiSetVolume
        xor eax, eax
        mov al, byte [crowddriver]
        mov ebx, 24h
        mov edx, 8
        call MidiNoteOff
        jmp short .14
.13:
        cmp dword [crowdvol8], byte 0
        jne short .14
        test ecx, ecx
        jle short .14
        xor eax, eax
        mov al, byte [crowddriver]
        mov ebx, 7Dh
        mov edx, 8
        call MidiProgramChange
        xor eax, eax
        mov al, byte [crowddriver]
        mov ebx, 24h
        mov edx, 8
        call MidiNoteOn
        xor eax, eax
        mov al, byte [crowddriver]
        mov ebx, 40h
        mov edx, 8
        call MidiPitchBend
.14:
        test ecx, ecx
        jle short .18
        xor eax, eax
        mov al, byte [crowddriver]
        mov ebx, ecx
        mov edx, 8
        call MidiSetVolume
        cmp ecx, byte 7Fh
        jge short .15
        cmp dword [crowdvol8], byte 7Fh
        jl short .18
.15:
        cmp ecx, byte 7Fh
        jl short .16
        mov eax, 6
        call randomd0
        cwde
        jmp short .17
.16:
        xor eax, eax
.17:
        mov ebx, 40h
        sub ebx, eax
        xor eax, eax
        mov al, byte [crowddriver]
        mov edx, 8
        call MidiPitchBend
.18:
        mov dword [crowdvol8], ecx
        cmp dword [crowdvol7], byte 0
        jne short .19
        test esi, esi
        jle short .19
        xor eax, eax
        mov al, byte [crowddriver]
        mov ebx, 7Eh
        mov edx, 7
        call MidiProgramChange
        xor eax, eax
        mov al, byte [crowddriver]
        mov ebx, 24h
        mov edx, 7
        call MidiNoteOn
.19:
        xor eax, eax
        mov al, byte [crowddriver]
        mov ebx, esi
        mov edx, 7
        call MidiSetVolume
        mov ebx, 3
        mov eax, esi
        mov edx, esi
        sar edx, 1Fh
        idiv ebx
        lea ebx, [byte eax+020h]
        test byte [sounddev], 8
        je short .20
        mov eax, 32h
        jmp short .21
.20:
        xor eax, eax
.21:
        add eax, byte 0Ah
        cmp esi, eax
        jne short .22
        mov eax, 6
        call randomd0
        cwde
        add ebx, eax
.22:
        xor eax, eax
        mov al, byte [crowddriver]
        mov edx, 7
        call MidiPitchBend
        mov dword [crowdvol7], esi
.x:
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CrowdNoiseOff                                59748  95 PC, medium confidence
; PC MIDI crowd noise off: for channels 8 and 7 when playing
; (crowdvol8/crowdvol7 > 0): volume 0, note 24h off (MidiNoteOff, 80h), clears
; the level
;-----------------------------------------------------------------------------
; C: src/engine/sound/CrowdNoiseOff.c
%ifdef CBUILD
%include "c/engine/sound/CrowdNoiseOff.inc"
%else
CrowdNoiseOff:
        push dword 10h
        call __CHK
        push ebx
        push edx
        push esi
        test byte [gameopts], 80h
        je near .x
        test byte [sounddev], 2Ah
        je short .x
        cmp dword [crowdvol8], byte 0
        jle short .1
        xor eax, eax
        mov al, byte [crowddriver]
        xor ebx, ebx
        mov edx, 8
        call MidiSetVolume
        xor eax, eax
        mov al, byte [crowddriver]
        mov ebx, 24h
        mov edx, 8
        call MidiNoteOff
        xor ebx, ebx
        mov dword [crowdvol8], ebx
.1:
        cmp dword [crowdvol7], byte 0
        jle short .x
        xor eax, eax
        mov al, byte [crowddriver]
        xor ebx, ebx
        mov edx, 7
        call MidiSetVolume
        xor eax, eax
        mov al, byte [crowddriver]
        mov ebx, 24h
        mov edx, 7
        call MidiNoteOff
        xor esi, esi
        mov dword [crowdvol7], esi
.x:
        pop esi
        pop edx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CrowdFadeOut                                 597E3  95 PC, medium confidence
; Saves crowdlevel, then while it is > 0: wait a tick
; (SetTickDeadline/WaitTickDeadline), crowdlevel -= 32h, CrowdNoiseUpdate(2);
; then CrowdNoiseOff and restores crowdlevel; called at game exit / screen
; changes
;-----------------------------------------------------------------------------
; C: src/engine/sound/CrowdFadeOut.c
%ifdef CBUILD
%include "c/engine/sound/CrowdFadeOut.inc"
%else
CrowdFadeOut:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov esi, dword [crowdlevel-2]
        sar esi, 10h
        test byte [gameopts], 80h
        je short .x
        test byte [sounddev], 2Ah
        je short .x
.1:
        cmp word [crowdlevel], byte 0
        jle short .3
        push byte 1
        call SetTickDeadline
        add esp, byte 4
        mov bx, word [crowdlevel]
        sub ebx, byte 32h
        mov word [crowdlevel], bx
        test bx, bx
        jge short .2
        xor edi, edi
        mov word [crowdlevel], di
.2:
        mov eax, 2
        call Crowd_Noise
        call WaitTickDeadline
        jmp short CrowdFadeOut.1
.3:
        call CrowdNoiseOff
        mov word [crowdlevel], si
.x:
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CrowdNoiseReset                              59863  95 PC, medium confidence
; Clears crowdsmooth, crowdvol8, crowdvol7 (called with crowdlevel = 0 at
; game start)
;-----------------------------------------------------------------------------
; C: src/engine/sound/CrowdNoiseReset.c
%ifdef CBUILD
%include "c/engine/sound/CrowdNoiseReset.inc"
%else
CrowdNoiseReset:
        push dword 8
        call __CHK
        push edx
        xor edx, edx
        mov dword [crowdsmooth], edx
        mov dword [crowdvol8], edx
        mov dword [crowdvol7], edx
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; sfx                               59884  94G middle94.asm, medium confidence
; Play sound effect id (remembered in lastsfx): while speech plays only 9Ch
; passes (and in a replay only with oneminsaid); A0h/A1h not on sound devices
; 4/8; 7Dh raises crowdlevel by 500; AAh on device 4 starts sample
; dword_ED7A4; 90h also plays 91h (both on device 4).
;-----------------------------------------------------------------------------
; C: src/engine/sound/sfx.c
%ifdef CBUILD
%include "c/engine/sound/sfx.inc"
%else
sfx:
        push dword 0Ch
        call __CHK
        push ecx
        push edx
        mov edx, eax
        mov word [lastsfx], ax
        call PaSpeechBusy
        test eax, eax
        je short .1
        cmp edx, 9Ch
        jne near .x
        test byte [gmode], 10h
        je short .1
        cmp dword [oneminsaid], byte 0
        je near .x
.1:
        mov ecx, dword [sounddev]
        cmp ecx, byte 8
        je short .2
        cmp ecx, byte 4
        jne short .3
.2:
        cmp edx, 0A0h
        je near .x
        cmp edx, 0A1h
        je short .x
.3:
        cmp edx, byte 7Dh
        jne short .4
        add word [crowdlevel], 1F4h
        pop edx
        pop ecx
        ret
.4:
        cmp dword [sounddev], byte 4
        jne short .5
        cmp edx, 0AAh
        jne short .5
        mov edx, dword [dword_D2427]
        mov eax, dword [dword_ED7A4]
        call PlaySong
        pop edx
        pop ecx
        ret
.5:
        cmp edx, 90h
        jne short .7
        cmp dword [sounddev], byte 4
        jne short .6
        xor eax, eax
        mov ax, dx
        call PlayPatchFull
.6:
        inc edx
.7:
        xor eax, eax
        mov ax, dx
        call PlayPatchFull
.x:
        pop edx
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; FreeDigiSample                               59945  95 PC, medium confidence
; When digihandle is set and SongFinished says it is not playing, frees it with
; ReleaseSong and sets digihandle -1; no callers
;-----------------------------------------------------------------------------
; C: src/engine/sound/FreeDigiSample.c
%ifdef CBUILD
%include "c/engine/sound/FreeDigiSample.inc"
%else
FreeDigiSample:
        push dword 0Ch
        call __CHK
        push ebx
        push edx
        mov edx, eax
        mov ebx, dword [digihandle]
        cmp ebx, byte 0FFFFFFFFh
        je short .x
        mov eax, ebx
        call SongFinished
        test ax, ax
        jne short .x
        mov eax, dword [digihandle]
        call ReleaseSong
        mov dword [digihandle], 0FFFFFFFFh
.x:
        pop edx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; StopDigiSample                               59981  95 PC, medium confidence
; If digihandle is set and still playing (SongFinished returns 0) stops it
; (StopSongId); digihandle = -1
;-----------------------------------------------------------------------------
; C: src/engine/sound/StopDigiSample.c
%ifdef CBUILD
%include "c/engine/sound/StopDigiSample.inc"
%else
StopDigiSample:
        push dword 8
        call __CHK
        push edx
        mov edx, dword [digihandle]
        cmp edx, byte 0FFFFFFFFh
        je short .x
        mov eax, edx
        call SongFinished
        test ax, ax
        jne short .x
        mov eax, dword [digihandle]
        call StopSongId
        mov dword [digihandle], 0FFFFFFFFh
.x:
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; PlayDigiSample                               599B9  95 PC, medium confidence
; StopDigiSample, then unless the sound device (sounddev) has bits 11h, plays
; sample eax via PlaySong on dword_D2427 and keeps the handle in digihandle
;-----------------------------------------------------------------------------
; C: src/engine/sound/PlayDigiSample.c
%ifdef CBUILD
%include "c/engine/sound/PlayDigiSample.inc"
%else
PlayDigiSample:
        push dword 0Ch
        call __CHK
        push ebx
        push edx
        mov ebx, eax
        call StopDigiSample
        test byte [sounddev], 11h
        jne short .x
        test ebx, ebx
        je short .x
        mov edx, dword [dword_D2427]
        mov eax, ebx
        call PlaySong
        mov dword [digihandle], eax
.x:
        pop edx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; WaitDigiSample                               599EE  95 PC, medium confidence
; Busy-waits until the sample in digihandle is done (SongFinished non-zero)
;-----------------------------------------------------------------------------
; C: src/engine/sound/WaitDigiSample.c
%ifdef CBUILD
%include "c/engine/sound/WaitDigiSample.inc"
%else
WaitDigiSample:
        push dword 4
        call __CHK
        cmp dword [digihandle], byte 0FFFFFFFFh
        je short .x
.1:
        mov eax, dword [digihandle]
        call SongFinished
        test ax, ax
        je short WaitDigiSample.1
.x:
        ret
%endif ; C
;-----------------------------------------------------------------------------
; PlayCrowdSample                                 59A11  95 PC, low confidence
; Eax < 6: sample from rockteamcues[eax] (else falls back to a random 6-8);
; plays crowdsamples entries 0-8 or leaguesetimg entries 9-11 with
; PlayDigiSample; callers pass 0, 2, 3, 9, 0Ah, 0Bh (goal / end-of-game
; sequences)
;-----------------------------------------------------------------------------
; C: src/engine/sound/PlayCrowdSample.c
%ifdef CBUILD
%include "c/engine/sound/PlayCrowdSample.inc"
%else
PlayCrowdSample:
        push dword 0Ch
        call __CHK
        push ebx
        push edx
        cmp eax, byte 6
        jge short .2
        shl eax, 2
        mov edx, dword [dword eax+rockteamcues]
        test edx, edx
        je short .1
        mov eax, edx
        call PlayDigiSample
        mov eax, 0Ch
        jmp short .2
.1:
        call rand_
        mov edx, eax
        and edx, 7FFFh
        mov ebx, 3
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        lea eax, [byte edx+06h]
.2:
        mov edx, eax
        shl edx, 2
        cmp eax, byte 9
        jge short .3
        mov eax, dword [dword edx+crowdsamples]
        jmp short .4
.3:
        cmp eax, byte 0Ch
        jge short .5
        mov eax, dword [dword edx+leaguesetimg]
.4:
        call PlayDigiSample
.5:
        pop edx
        pop ebx
PlayCrowdSample_ret:
        ret
;-----------------------------------------------------------------------------
; PaOneMinuteLeft                              59A7E  95 PC, medium confidence
; If musicon and announcer option (gameopts+1 bit 0) and not gmode 10h:
; MusicChanReset, SayOneMinuteLeft
;-----------------------------------------------------------------------------
PaOneMinuteLeft:
        push dword 4
        call __CHK
        cmp byte [musicon], 0
        je short PlayCrowdSample_ret
        test byte [gameopts+1], 1
        je short PlayCrowdSample_ret
        test byte [gmode], 10h
        jne short PlayCrowdSample_ret
        call MusicChanReset
        jmp near SayOneMinuteLeft
%endif ; C
;-----------------------------------------------------------------------------
; PaSpeechBusy                                 59AAD  95 PC, medium confidence
; SpeechBusy when musicon and announcer option, else 0
;-----------------------------------------------------------------------------
; C: src/engine/sound/PaSpeechBusy.c
%ifdef CBUILD
%include "c/engine/sound/PaSpeechBusy.inc"
%else
PaSpeechBusy:
        push dword 4
        call __CHK
        cmp byte [musicon], 0
        je short .1
        test byte [gameopts+1], 1
        jne near SpeechBusy
.1:
        xor eax, eax
        ret
%endif ; C
;-----------------------------------------------------------------------------
; PaGoal                                       59AD0  95 PC, medium confidence
; Guarded MusicChanReset + SayGoal
;-----------------------------------------------------------------------------
; C: src/engine/sound/PaGoal.c
%ifdef CBUILD
%include "c/engine/sound/PaGoal.inc"
%else
PaGoal:
        push dword 10h
        call __CHK
        push esi
        push edi
        mov esi, eax
        cmp byte [musicon], 0
        je short .x
        test byte [gameopts+1], 1
        je short .x
        test byte [gmode], 10h
        jne short .x
        call MusicChanReset
        mov edi, dword [byte esp+0Ch]
        push edi
        mov eax, esi
        call SayGoal
.x:
        pop edi
        pop esi
        ret 4
%endif ; C
;-----------------------------------------------------------------------------
; PaPlayerNumber                               59B0F  95 PC, medium confidence
; Guarded MusicChanReset + SayPlayerNumber
;-----------------------------------------------------------------------------
; C: src/engine/sound/PaPlayerNumber.c
%ifdef CBUILD
%include "c/engine/sound/PaPlayerNumber.inc"
%else
PaPlayerNumber:
        push dword 8
        call __CHK
        push ecx
        mov ecx, eax
        cmp byte [musicon], 0
        je short .x
        test byte [gameopts+1], 1
        je short .x
        call MusicChanReset
        mov eax, ecx
        call SayPlayerNumber
.x:
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; PaPenalty                                    59B3C  95 PC, medium confidence
; Guarded MusicChanReset + SayPenalty
;-----------------------------------------------------------------------------
; C: src/engine/sound/PaPenalty.c
%ifdef CBUILD
%include "c/engine/sound/PaPenalty.inc"
%else
PaPenalty:
        push dword 24h
        call __CHK
        push esi
        push edi
        push ebp
        mov esi, eax
        cmp byte [musicon], 0
        je short .x
        test byte [gameopts+1], 1
        je short .x
        call MusicChanReset
        mov edi, dword [byte esp+020h]
        push edi
        mov ebp, dword [byte esp+020h]
        push ebp
        mov eax, dword [byte esp+020h]
        push eax
        mov edi, dword [byte esp+020h]
        push edi
        mov ebp, dword [byte esp+020h]
        push ebp
        mov eax, esi
        call SayPenalty
.x:
        pop ebp
        pop edi
        pop esi
        ret 14h
%endif ; C
;-----------------------------------------------------------------------------
; PaPenaltyShot                                59B88  95 PC, medium confidence
; Guarded MusicChanReset + SayPenaltyShot
;-----------------------------------------------------------------------------
; C: src/engine/sound/PaPenaltyShot.c
%ifdef CBUILD
%include "c/engine/sound/PaPenaltyShot.inc"
%else
PaPenaltyShot:
        push dword 8
        call __CHK
        push esi
        mov esi, eax
        cmp byte [musicon], 0
        je short .x
        test byte [gameopts+1], 1
        je short .x
        call MusicChanReset
        mov eax, esi
        call SayPenaltyShot
.x:
        pop esi
        ret
%endif ; C
;-----------------------------------------------------------------------------
; PaTonightIntro                               59BB5  95 PC, medium confidence
; Team indices -> teamabbrevs, SayTonightIntro
;-----------------------------------------------------------------------------
; C: src/engine/sound/PaTonightIntro.c
%ifdef CBUILD
%include "c/engine/sound/PaTonightIntro.inc"
%else
PaTonightIntro:
        push dword 0Ch
        call __CHK
        push ebx
        push ecx
        mov ecx, eax
        cmp eax, byte 1Ah
        jl short .1
        mov ecx, 0Ch
.1:
        cmp byte [musicon], 0
        je short .2
        test byte [gameopts+1], 1
        je short .2
        mov ebx, dword [nosplit eax*4+teamabbrevs]
        mov edx, dword [nosplit edx*4+teamabbrevs]
        mov eax, dword [nosplit ecx*4+teamabbrevs]
        call SayTonightIntro
.2:
        pop ecx
        pop ebx
PaTonightIntro_ret:
        ret
;-----------------------------------------------------------------------------
; PaScoringPeriod                              59BFC  95 PC, medium confidence
; Guarded SayScoringPeriod
;-----------------------------------------------------------------------------
PaScoringPeriod:
        push dword 4
        call __CHK
        cmp byte [musicon], 0
        je short PaTonightIntro_ret
        test byte [gameopts+1], 1
        je short PaTonightIntro_ret
        jmp near SayScoringPeriod
;-----------------------------------------------------------------------------
; PaNhlIntro                                   59C1D  95 PC, medium confidence
; Guarded SayNhlIntro
;-----------------------------------------------------------------------------
PaNhlIntro:
        push dword 4
        call __CHK
        cmp byte [musicon], 0
        je short PaTonightIntro_ret
        test byte [gameopts+1], 1
        je short PaTonightIntro_ret
        jmp near SayNhlIntro
;-----------------------------------------------------------------------------
; PaGoodnight                                  59C3E  95 PC, medium confidence
; Guarded SayGoodnight
;-----------------------------------------------------------------------------
PaGoodnight:
        push dword 4
        call __CHK
        cmp byte [musicon], 0
        je short PaTonightIntro_ret
        test byte [gameopts+1], 1
        je short PaTonightIntro_ret
        jmp near SayGoodnight
;-----------------------------------------------------------------------------
; PaLineups                                    59C5F  95 PC, medium confidence
; Guarded SayLineups
;-----------------------------------------------------------------------------
PaLineups:
        push dword 4
        call __CHK
        cmp byte [musicon], 0
        je short PaTonightIntro_ret
        test byte [gameopts+1], 1
        je short PaTonightIntro_ret
        jmp near SayLineups
;-----------------------------------------------------------------------------
; PaElseNhl                                    59C80  95 PC, medium confidence
; Guarded SayElseNhl
;-----------------------------------------------------------------------------
PaElseNhl:
        push dword 4
        call __CHK
        cmp byte [musicon], 0
        je near PaTonightIntro_ret
        test byte [gameopts+1], 1
        je near PaTonightIntro_ret
        jmp near SayElseNhl
%endif ; C
;-----------------------------------------------------------------------------
; PaHighlightIntro                             59CA9  95 PC, medium confidence
; Team abbrevs + SayHighlightIntro
;-----------------------------------------------------------------------------
; C: src/engine/sound/PaHighlightIntro.c
%ifdef CBUILD
%include "c/engine/sound/PaHighlightIntro.inc"
%else
PaHighlightIntro:
        push dword 8
        call __CHK
        push ebx
        cmp byte [musicon], 0
        je short .x
        test byte [gameopts+1], 1
        je short .x
        mov eax, dword [nosplit eax*4+teamabbrevs]
        mov edx, dword [nosplit edx*4+teamabbrevs]
        mov ebx, eax
        call SayHighlightIntro
.x:
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; PaPlayoffResult                              59CDD  95 PC, medium confidence
; Team abbrev + SayPlayoffResult
;-----------------------------------------------------------------------------
; C: src/engine/sound/PaPlayoffResult.c
%ifdef CBUILD
%include "c/engine/sound/PaPlayoffResult.inc"
%else
PaPlayoffResult:
        push dword 14h
        call __CHK
        push esi
        push edi
        cmp byte [musicon], 0
        je short .x
        test byte [gameopts+1], 1
        je short .x
        mov esi, dword [byte esp+010h]
        push esi
        mov edi, dword [byte esp+010h]
        push edi
        mov eax, dword [nosplit eax*4+teamabbrevs]
        call SayPlayoffResult
.x:
        pop edi
        pop esi
        ret 8
%endif ; C
;-----------------------------------------------------------------------------
; PaPlayoffTonight                             59D16  95 PC, medium confidence
; Team abbrevs + SayPlayoffTonight
;-----------------------------------------------------------------------------
; C: src/engine/sound/PaPlayoffTonight.c
%ifdef CBUILD
%include "c/engine/sound/PaPlayoffTonight.inc"
%else
PaPlayoffTonight:
        push dword 10h
        call __CHK
        push esi
        cmp byte [musicon], 0
        je short .x
        test byte [gameopts+1], 1
        je short .x
        mov esi, dword [byte esp+08h]
        push esi
        push ecx
        mov eax, dword [nosplit eax*4+teamabbrevs]
        mov edx, dword [nosplit edx*4+teamabbrevs]
        mov ecx, ebx
        mov ebx, eax
        call SayPlayoffTonight
.x:
        pop esi
        ret 4
%endif ; C
;-----------------------------------------------------------------------------
; PaOpenBank                                   59D54  95 PC, medium confidence
; When musicon: retry OpenAnnouncerBank until it succeeds
;-----------------------------------------------------------------------------
; C: src/engine/sound/PaOpenBank.c
%ifdef CBUILD
%include "c/engine/sound/PaOpenBank.inc"
%else
PaOpenBank:
        push dword 4
        call __CHK
        cmp byte [musicon], 0
        je short .x
.1:
        call OpenAnnouncerBank
        test eax, eax
        je short PaOpenBank.1
.x:
        ret
%endif ; C
;-----------------------------------------------------------------------------
; PaPreloadClips                               59D71  95 PC, medium confidence
; When musicon: retry PreloadAnnouncerClips until it succeeds
;-----------------------------------------------------------------------------
; C: src/engine/sound/PaPreloadClips.c
%ifdef CBUILD
%include "c/engine/sound/PaPreloadClips.inc"
%else
PaPreloadClips:
        push dword 0Ch
        call __CHK
        push ebx
        push ecx
        mov ebx, eax
        mov ecx, edx
        cmp byte [musicon], 0
        je short .x
.1:
        mov edx, ecx
        mov eax, ebx
        call PreloadAnnouncerClips
        test eax, eax
        je short PaPreloadClips.1
.x:
        pop ecx
        pop ebx
        ret
%endif ; C
