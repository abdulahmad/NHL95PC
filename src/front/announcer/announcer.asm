; The announcer. The timer that feeds the speech queue, the speech bank, loading samples into memory
; and finding a free slot, and building a sentence from clips for a goal, a penalty, a score, and the
; playoff round. One module (ShutdownSpeech's exits).
bits 32
%include "hockey.inc"
section s_832BC progbits alloc exec nowrite align=1
extern __CHK, __CHP, __STOSD, _dos_close_, _dos_open_, _dos_read_, _fmemmove_, _os_handle_3
extern addtimer, str_04x, sndcardmissing, crowddriver, byte_D27B6, cddriveptr, ClearInputQueue, DrawSelBoxOff
extern DrawSelBoxOn, dword_C4CFC, cursndbank, oneminsaid, dword_D2350, dword_D2423, dword_D2427, digidriver
extern sndtempbuf, str_Cor2, speechchannel, dword_ED7A4, dword_ED7A8, FatalError, fclose_, fileoncd
extern fopen_, fprintf_, FreeMemBlock, gameopts, GetInputEvent, itoa_, lseek_, MakePath
extern MessageBox, msg_InitMT32, musichandle, musicon, musicslot, penaltyclips, PlayDigiSample, pointerspr
extern ptrupdatefn, qword_C37B0, qword_C37B8, qword_C37C0, qword_C37C8, qword_C37D0, RedrawSoundCardOpts, RemoveTimerCallback
extern RestoreDialogBg, samplereq, scorperclips, setbits, SetDialogColors, SetTickDeadline, sndcardname, songdata
extern SoundCardHitTest, sounddev, sounddevids, speechbank, speechcopybuf, speechcopylen, speechinit, speechq
extern sprintf_, str_02dS, str_1minuteCor, str_1secondCor, str_2minCor, str_5minCor, str_ADLIB, str_Adlib
extern str_AndBar, str_AndnumCor, str_AsstnumCor, str_AtCor, str_Awa, str_BackmomtInt, str_Bar, str_BetweenBar
extern str_CantOpenNhlCfg, str_CFG, str_CoachclpInt, str_Cor, str_DS, str_EasportsBar, str_EastfindBar, str_EastfinuBar
extern str_EastquadBar, str_EastquauBar, str_EastsemdBar, str_EastsemuBar, str_ElsenhlInt, str_Emmcopybuf, str_Frm, str_GamebtwnBar
extern str_GamemiscS, str_Gamenum, str_GamenumBar, str_GoalnumCor, str_GoodniteInt, str_HavewonBar, str_HighliteBar, str_Hom
extern str_Iff12, str_LineupsInt, str_Maindesk2, str_MinutesCor, str_MT322, str_MT323, str_MT32HOCK, str_NHL3
extern str_NhlInt, str_NowbackInt, str_Num, str_NumberCor, str_OfBar, str_OneleftCor, str_OvertimeBar, str_PauseCor
extern str_PC, str_PCBEEP, str_PCBEEP2, str_Pen, str_PennumCor, str_PenshotCor, str_PensnumCor, str_Pointer21
extern str_Rnk, str_SampleMemMan, str_SBDAC, str_SBDAC2, str_Scor1otpBar, str_Scor1perBar, str_Scor2otpBar, str_Scor2perBar
extern str_Scor3otpBar, str_Scor3perBar, str_ScortotpBar, str_SecondsCor, str_Sentence, str_Slapshot, str_SoundBlaster2, str_SpeechBank
extern str_Speechbuf, str_SS5, str_SSS, str_StanleydBar, str_StanleyuBar, str_TakeynowBar, str_Tea, str_ThegameBar
extern str_TonightBar, str_ULTRASOUND, str_VIV, str_WestfindBar, str_WestfinuBar, str_WestquadBar, str_WestquauBar, str_WestsemdBar
extern str_WestsemuBar, str_XBRUCE2, strcpy_, strncpy_, sub_8CC70, AllocMemBlock, sub_8D2F0, sub_8DBD4
extern sub_8EB5B, sub_8EB93, sub_8ECC0, LoadSample, FreeSample, sub_8F98F, sub_8FB8E, sub_8FBE5
extern sub_8FC37, SndQuery, sub_8FCAC, sub_8FCDF, PutBlock, DrawArt, GrabBlock, sub_97079
extern sub_98028, MouseRead, sub_B4BA8, str_R4, sndselbox1, sndselbox2, msg_NoSoundCard, WaitDigiSample
extern WaitTickDeadline
global SpeechTimerTick, ClearSpeechSlot, ResetSpeechQueue, InitSpeechSlots, ResetSampleReq, InitSpeech, ShutdownSpeech, ShutdownSpeech_ret6
global ShutdownSpeech_ret5, SpeechIsInit, SpeechBusy, SpeechIdle, MusicChanReset2, SpeechStopQueue, MusicChanCmd3, MusicChanReset
global Swap16, ReadBE24, ReadBE24_ret, ReadCString, OpenSpeechBank, OpenSpeechBank_ret, SpeechSlotSize, ReadSpeechSample
global LoadSpeechSlot, PlaceSpeechSlot, StrEqNoCase, FindFreeSpeechSlot, FindLoadedSpeechSlot, FindSpeechSlot, SpeechSlotLoaded, IsSampleRequested
global RequestSample, FreeUnrequestedSamples, MoveSampleMem, CompactSpeechSlot, MakeSampleRoom, EnsureSampleRoom, CompactSpeechMem, PenaltyLenClip
global PlayoffRoundClipD, PlayoffRoundClipU, QueueSpeechClip, LoadClipSlot, SayClip_body, SayScorePeriod, SayNhlIntro, SayGoodnight
global SayLineups, SayNowBack, FreeNowBack, SayBackMoment, FreeBackMoment, SayCoachClip, FreeCoachClip, FreeClip
global FreeClip_ret, SayElseNhl, SayHighlightIntro, SayPlayoffResult, SayTheGame, SayScoringPeriod, SayClip, SayScoringPeriod_ot2
global SayScoringPeriod_ot3, SayScoringPeriod_ott, SayScoringPeriod_reg, SayTonightIntro, SayPlayoffTonight, RequestTimeClips, QueueTimeClips, SayPenalty
global SayPenaltyShot, SayPlayerNumber, SayGoal, SayOneMinuteLeft, OpenAnnouncerBank, QueuePenaltyType, PreloadAnnouncerClips
;-----------------------------------------------------------------------------
; SpeechTimerTick                              832BC  95 PC, medium confidence
; Timer callback installed by InitSpeech (addtimer): counts down and starts
; next queued speech sample
;-----------------------------------------------------------------------------
; C: src/front/announcer/ShutdownSpeech.c (SpeechTimerTick)
%ifdef CBUILD
%include "c/front/announcer/ShutdownSpeech.SpeechTimerTick.inc"
%else
SpeechTimerTick:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        cmp dword [speechinit], byte 0
        je near ShutdownSpeech_ret5
        mov eax, dword [speechq]
        mov ebx, dword [byte eax+05Ch]
        test ebx, ebx
        je short .1
        lea ecx, [byte ebx-01h]
        mov dword [byte eax+05Ch], ecx
.1:
        mov eax, dword [speechq]
        cmp dword [byte eax+060h], byte 0
        je near ShutdownSpeech_ret5
        mov edi, dword [byte eax+050h]
        test edi, edi
        je short .2
        lea ecx, [byte edi-01h]
        mov dword [byte eax+050h], ecx
        jmp near ShutdownSpeech_ret5
.2:
        mov ecx, dword [byte eax+058h]
        lea edx, [byte ecx+01h]
        mov dword [byte eax+058h], edx
        mov edx, dword [speechq]
        cmp ecx, dword [byte edx+054h]
        jge near .5
        mov eax, ecx
        mov ecx, dword [edx+eax*4]
        cmp ecx, byte 0FFFFFFFFh
        jne short .3
        mov dword [byte edx+060h], edi
        jmp near ShutdownSpeech_ret5
.3:
        mov eax, ecx
        shl eax, 2
        add eax, ecx
        shl eax, 2
        sub eax, ecx
        add eax, eax
        mov ebx, dword [speechbank]
        add eax, ebx
        mov esi, dword [byte eax+0Eh]
        mov ecx, dword [byte eax+016h]
        mov ebx, dword [byte eax+01Eh]
        mov dword [byte edx+050h], ebx
        mov edx, dword [speechchannel]
        inc edx
        mov dword [speechchannel], edx
        mov ebx, edx
        and ebx, byte 1
        mov dword [speechchannel], ebx
        cmp byte [byte eax+0Dh], 47h
        jne short .4
        push byte 7Fh
        push dword 2B11h
        mov edx, dword [musichandle]
        mov eax, esi
        call sub_8FBE5
        jmp near ShutdownSpeech_ret5
.4:
        add ecx, ecx
        push byte 7Fh
        push dword 2B11h
        mov edx, dword [musichandle]
        mov eax, esi
        call sub_8FC37
        jmp near ShutdownSpeech_ret5
.5:
        mov dword [byte edx+060h], edi
        mov eax, dword [speechbank]
        mov edx, dword [speechq]
        mov eax, dword [dword eax+03B70h]
        mov dword [byte edx+05Ch], eax
        jmp near ShutdownSpeech_ret5
%endif ; C
;-----------------------------------------------------------------------------
; ClearSpeechSlot                              833C5  95 PC, medium confidence
; Zeroes fields 0,0Dh,0Eh..22h of a speech slot struct
;-----------------------------------------------------------------------------
; C: src/front/announcer/ClearSpeechSlot.c
%ifdef CBUILD
%include "c/front/announcer/ClearSpeechSlot.inc"
%else
ClearSpeechSlot:
        push dword 4
        call __CHK
        mov byte [eax], 0
        mov byte [byte eax+0Dh], 0
        mov dword [byte eax+0Eh], 0
        mov dword [byte eax+012h], 0
        mov dword [byte eax+016h], 0
        mov dword [byte eax+01Eh], 0
        mov dword [byte eax+022h], 0
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ResetSpeechQueue                             833FA  95 PC, medium confidence
; Fills 20 queue entries with -1 and clears counters +50h..+60h
;-----------------------------------------------------------------------------
; C: src/front/announcer/ResetSpeechQueue.c
%ifdef CBUILD
%include "c/front/announcer/ResetSpeechQueue.inc"
%else
ResetSpeechQueue:
        push dword 0Ch
        call __CHK
        push ecx
        push edx
        mov eax, dword [speechq]
        mov dword [byte eax+060h], 0
        mov eax, dword [speechq]
        mov ecx, 14h
        mov edx, 0FFFFFFFFh
        call __STOSD
        mov eax, dword [speechq]
        mov dword [byte eax+054h], 0
        mov eax, dword [speechq]
        mov dword [byte eax+058h], 0
        mov eax, dword [speechq]
        mov dword [byte eax+050h], 0
        mov eax, dword [speechq]
        mov dword [byte eax+05Ch], 0
        pop edx
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; InitSpeechSlots                              83459  95 PC, medium confidence
; Clears 400 38-byte slots in speechbank, sets mem limit (arg-1388h), allocs
; 'speechbuf'
;-----------------------------------------------------------------------------
; C: src/front/announcer/InitSpeechSlots.c
%ifdef CBUILD
%include "c/front/announcer/InitSpeechSlots.inc"
%else
InitSpeechSlots:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push edx
        mov ecx, eax
        xor edx, edx
.1:
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        mov ebx, dword [speechbank]
        add eax, ebx
        call ClearSpeechSlot
        inc edx
        cmp edx, 190h
        jl short InitSpeechSlots.1
        mov eax, dword [speechbank]
        lea edx, [dword ecx-01388h]
        mov dword [dword eax+03B68h], edx
        mov edx, dword [cursndbank]
        push edx
        push ecx
        push str_Speechbuf
        call sub_8CC70
        add esp, byte 0Ch
        mov edx, dword [speechbank]
        mov dword [dword edx+03B60h], eax
        mov eax, dword [speechbank]
        mov ebx, dword [dword eax+03B60h]
        push ebx
        call sub_8DBD4
        add esp, byte 4
        mov edx, dword [speechbank]
        mov dword [dword edx+03B64h], eax
        mov eax, dword [speechbank]
        mov dword [dword eax+03B6Ch], 0
        mov eax, dword [speechbank]
        mov dword [dword eax+03B74h], 0
        mov eax, dword [speechbank]
        mov dword [dword eax+03B70h], 0
        mov eax, dword [speechbank]
        mov dword [dword eax+03B78h], 0
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ResetSampleReq                               83520  95 PC, medium confidence
; Clears 20 13-byte names and counters +104h..+10Ch of samplereq
;-----------------------------------------------------------------------------
; C: src/front/announcer/ResetSampleReq.c
%ifdef CBUILD
%include "c/front/announcer/ResetSampleReq.inc"
%else
ResetSampleReq:
        push dword 0Ch
        call __CHK
        push ebx
        push edx
        xor edx, edx
.1:
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        lea ebx, [edx+eax]
        mov eax, dword [samplereq]
        mov byte [ebx+eax], 0
        inc edx
        cmp edx, byte 14h
        jl short ResetSampleReq.1
        mov eax, dword [samplereq]
        mov dword [dword eax+010Ch], 0
        mov eax, dword [samplereq]
        mov dword [dword eax+0108h], 0
        mov eax, dword [samplereq]
        mov dword [dword eax+0104h], 0
        pop edx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; InitSpeech                                   8357A  95 PC, medium confidence
; Allocs 'sentence' queue, 'sample mem man', 'speech bank', InitSpeechSlots,
; installs SpeechTimerTick, sets speechinit
;-----------------------------------------------------------------------------
; C: src/front/announcer/InitSpeech.c
%ifdef CBUILD
%include "c/front/announcer/InitSpeech.inc"
%else
InitSpeech:
        push dword 1Ch
        call __CHK
        push esi
        push edi
        sub esp, byte 4
        mov byte [esp], al
        mov esi, edx
        call SpeechIsInit
        test eax, eax
        jne near .x
        mov al, byte [esp]
        mov byte [byte_D27B6], al
        xor edx, edx
        mov dword [speechchannel], edx
        mov dword [speechcopybuf], ebx
        mov dword [speechcopylen], ecx
        mov ebx, dword [cursndbank]
        push ebx
        push byte 64h
        push str_Sentence
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [speechq], eax
        call ResetSpeechQueue
        mov ecx, dword [cursndbank]
        push ecx
        push dword 110h
        push str_SampleMemMan
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [samplereq], eax
        call ResetSampleReq
        mov edi, dword [cursndbank]
        push edi
        push dword 3B93h
        push str_SpeechBank
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [speechbank], eax
        mov eax, esi
        call InitSpeechSlots
        push SpeechTimerTick
        call addtimer
        add esp, byte 4
        mov dword [speechinit], 1
.x:
        add esp, byte 4
        pop edi
        pop esi
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ShutdownSpeech                               8363C  95 PC, medium confidence
; Removes timer callback, closes bank file, frees buffers, clears speechinit;
; called by SetSoundDevice
;-----------------------------------------------------------------------------
; C: src/front/announcer/ShutdownSpeech.c
%ifdef CBUILD
%include "c/front/announcer/ShutdownSpeech.inc"
%else
ShutdownSpeech:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        cmp dword [speechinit], byte 0
        je short ShutdownSpeech_ret6
        push SpeechTimerTick
        call RemoveTimerCallback
        add esp, byte 4
        mov eax, dword [speechbank]
        cmp dword [dword eax+03B78h], byte 0
        je short .1
        mov eax, dword [dword eax+03B7Ch]
        call _dos_close_
.1:
        mov ecx, dword [speechq]
        push ecx
        call FreeMemBlock
        add esp, byte 4
        mov eax, dword [speechbank]
        mov esi, dword [dword eax+03B60h]
        push esi
        call sub_8D2F0
        add esp, byte 4
        mov edi, dword [speechbank]
        push edi
        call FreeMemBlock
        add esp, byte 4
        mov ebp, dword [samplereq]
        push ebp
        call FreeMemBlock
        add esp, byte 4
        xor eax, eax
        mov dword [speechinit], eax
ShutdownSpeech_ret6:
        pop ebp
ShutdownSpeech_ret5:
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SpeechIsInit                                 836CA  95 PC, medium confidence
; Returns speechinit != 0
;-----------------------------------------------------------------------------
; C: src/front/announcer/SpeechIsInit.c
%ifdef CBUILD
%include "c/front/announcer/SpeechIsInit.inc"
%else
SpeechIsInit:
        push dword 4
        call __CHK
        cmp dword [speechinit], byte 0
        setne al
        and eax, 0FFh
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SpeechBusy                                   836E4  95 PC, medium confidence
; Speechinit and (queue active or delay pending)
;-----------------------------------------------------------------------------
; C: src/front/announcer/SpeechBusy.c
%ifdef CBUILD
%include "c/front/announcer/SpeechBusy.inc"
%else
SpeechBusy:
        push dword 4
        call __CHK
        cmp dword [speechinit], byte 0
        je short .3
        mov eax, dword [speechq]
        cmp dword [byte eax+060h], byte 0
        je short .2
.1:
        mov eax, 1
        ret
.2:
        cmp dword [byte eax+05Ch], byte 0
        jne short SpeechBusy.1
.3:
        xor eax, eax
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SpeechIdle                                   83711  95 PC, medium confidence
; Speechinit and queue idle
;-----------------------------------------------------------------------------
; C: src/front/announcer/SpeechIdle.c
%ifdef CBUILD
%include "c/front/announcer/SpeechIdle.inc"
%else
SpeechIdle:
        push dword 4
        call __CHK
        cmp dword [speechinit], byte 0
        jne short .2
.1:
        xor eax, eax
        ret
.2:
        mov eax, dword [speechq]
        cmp dword [byte eax+060h], byte 0
        jne short SpeechIdle.1
        cmp dword [byte eax+05Ch], byte 0
        jne short SpeechIdle.1
        mov eax, 1
        ret
%endif ; C
;-----------------------------------------------------------------------------
; MusicChanReset2                              8373E  95 PC, medium confidence
; Wrapper around MusicChanReset
;-----------------------------------------------------------------------------
; C: src/front/announcer/MusicChanReset2.c
%ifdef CBUILD
%include "c/front/announcer/MusicChanReset2.inc"
%else
MusicChanReset2:
        push dword 4
        call __CHK
        call MusicChanReset
;-----------------------------------------------------------------------------
; SpeechStopQueue                              8374D  95 PC, medium confidence
; Clears queue active flag, sets hold delay from bank +3B70h
;-----------------------------------------------------------------------------
SpeechStopQueue:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        cmp dword [speechinit], byte 0
        je short .x
        mov eax, dword [speechq]
        mov dword [byte eax+060h], 0
        mov eax, dword [speechq]
        mov ebx, dword [speechbank]
        mov edx, dword [byte eax+050h]
        mov ecx, dword [dword ebx+03B70h]
        add edx, ecx
        mov dword [byte eax+05Ch], edx
.x:
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; MusicChanCmd3                                8378C  95 PC, medium confidence
; Sub_8FCAC(musichandle, 3)
;-----------------------------------------------------------------------------
; C: src/front/announcer/MusicChanCmd3.c
%ifdef CBUILD
%include "c/front/announcer/MusicChanCmd3.inc"
%else
MusicChanCmd3:
        push dword 8
        call __CHK
        push edx
        mov eax, dword [musichandle]
        mov edx, 3
        call sub_8FCAC
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; MusicChanReset                               837A8  95 PC, medium confidence
; When speechinit: sub_8FCAC(musichandle,0) then (musichandle,1)
;-----------------------------------------------------------------------------
; C: src/front/announcer/MusicChanReset.c
%ifdef CBUILD
%include "c/front/announcer/MusicChanReset.inc"
%else
MusicChanReset:
        push dword 8
        call __CHK
        push edx
        cmp dword [speechinit], byte 0
        je short .x
        mov eax, dword [musichandle]
        xor edx, edx
        call sub_8FCAC
        mov eax, dword [musichandle]
        mov edx, 1
        call sub_8FCAC
.x:
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; Swap16                                       837D9  95 PC, medium confidence
; Byte-swap 16-bit value
;-----------------------------------------------------------------------------
; C: src/front/announcer/Swap16.c
%ifdef CBUILD
%include "c/front/announcer/Swap16.inc"
%else
Swap16:
        push dword 8
        call __CHK
        push edx
        mov edx, eax
        and edx, 0FFh
        shl edx, 8
        shr eax, 8
        and eax, 0FFh
        or eax, edx
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ReadBE24                                     837FB  95 PC, medium confidence
; Reads three bytes big-endian from a DOS handle
;-----------------------------------------------------------------------------
; C: src/front/announcer/ShutdownSpeech.c (ReadBE24)
%ifdef CBUILD
%include "c/front/announcer/ShutdownSpeech.ReadBE24.inc"
%else
ReadBE24:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        sub esp, byte 8
        mov esi, eax
        xor ah, ah
        mov byte [byte esp+07h], ah
        mov ebx, esp
        push ebx
        mov edx, 1
        mov ecx, ds
        lea ebx, [byte esp+0Ah]
        mov eax, esi
        call _dos_read_
        mov ebx, esp
        push ebx
        mov edx, 1
        mov ecx, ds
        lea ebx, [byte esp+09h]
        mov eax, esi
        call _dos_read_
        mov ebx, esp
        push ebx
        mov edx, 1
        mov ecx, ds
        lea ebx, [byte esp+08h]
        mov eax, esi
        call _dos_read_
        mov eax, dword [byte esp+04h]
ReadBE24_ret:
        add esp, byte 8
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ReadCString                                  8385F  95 PC, medium confidence
; Reads bytes from a DOS handle until NUL
;-----------------------------------------------------------------------------
; C: src/front/announcer/ReadCString.c
%ifdef CBUILD
%include "c/front/announcer/ReadCString.inc"
%else
ReadCString:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        sub esp, byte 4
        mov esi, eax
        mov edi, edx
.1:
        mov eax, esp
        push eax
        mov ecx, ds
        mov edx, 1
        mov ebx, esi
        mov eax, edi
        call _dos_read_
        mov eax, esi
        inc esi
        cmp byte [eax], 0
        jne short ReadCString.1
        add esp, byte 4
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; OpenSpeechBank                               83897  95 PC, medium confidence
; Opens bank file (skips if same name), reads index of sample names / offsets
; / sizes into speechbank slots
;-----------------------------------------------------------------------------
OpenSpeechBank:
        push dword 40h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 24h
        mov esi, eax
        mov edi, edx
        cmp dword [speechinit], byte 0
        je near .10
        mov eax, dword [speechbank]
        cmp dword [dword eax+03B78h], byte 0
        je short .1
        lea edx, [dword eax+03B80h]
        mov eax, esi
        call StrEqNoCase
        test eax, eax
        jne near .10
        mov eax, dword [speechbank]
        mov eax, dword [dword eax+03B7Ch]
        call _dos_close_
.1:
        lea ebx, [byte esp+010h]
        xor edx, edx
        mov eax, esi
        call _dos_open_
        mov eax, dword [speechbank]
        add eax, 3B80h
        mov ebx, 0Dh
        mov edx, esi
        call strncpy_
        mov edx, dword [speechbank]
        mov eax, dword [byte esp+010h]
        mov dword [dword edx+03B7Ch], eax
        mov eax, dword [speechbank]
        mov dword [dword eax+03B70h], edi
        mov eax, dword [speechbank]
        mov dword [dword eax+03B78h], 1
        mov eax, dword [speechbank]
        mov dword [dword eax+03B6Ch], 0
        mov eax, dword [speechbank]
        mov dword [dword eax+03B74h], 0
        lea eax, [byte esp+08h]
        push eax
        mov edx, 2
        mov ecx, ds
        lea ebx, [byte esp+024h]
        mov eax, dword [byte esp+014h]
        call _dos_read_
        mov eax, dword [byte esp+01Eh]
        sar eax, 10h
        call Swap16
        mov edx, dword [speechbank]
        mov word [dword edx+03B8Dh], ax
        lea eax, [byte esp+08h]
        push eax
        mov edx, 2
        mov ecx, ds
        lea ebx, [byte esp+018h]
        mov eax, dword [byte esp+014h]
        call _dos_read_
        mov eax, dword [byte esp+012h]
        sar eax, 10h
        call Swap16
        mov edx, eax
        mov eax, dword [speechbank]
        mov word [dword eax+03B8Fh], dx
        lea eax, [byte esp+08h]
        push eax
        mov edx, 2
        mov ecx, ds
        lea ebx, [byte esp+020h]
        mov eax, dword [byte esp+014h]
        call _dos_read_
        mov eax, dword [byte esp+01Ah]
        sar eax, 10h
        call Swap16
        mov edx, dword [speechbank]
        mov word [dword edx+03B91h], ax
        xor esi, esi
        jmp short .3
.2:
        mov edi, esi
        shl edi, 2
        add edi, esi
        shl edi, 2
        sub edi, esi
        add edi, edi
        mov dword [byte edi+eax+0Eh], 0
        mov eax, dword [byte esp+010h]
        call ReadBE24
        mov edx, eax
        mov eax, dword [speechbank]
        mov dword [byte edi+eax+012h], edx
        mov eax, dword [byte esp+010h]
        call ReadBE24
        mov edx, dword [speechbank]
        mov dword [byte edx+edi+01Ah], eax
        mov eax, dword [speechbank]
        add eax, edi
        mov edx, dword [byte esp+010h]
        call ReadCString
        mov eax, dword [speechbank]
        mov dword [byte edi+eax+022h], 0
        inc esi
.3:
        mov eax, dword [speechbank]
        mov edx, dword [dword eax+03B8Fh]
        sar edx, 10h
        cmp esi, edx
        jl short OpenSpeechBank.2
        xor esi, esi
        jmp near .7
.4:
        mov edi, esi
        shl edi, 2
        add edi, esi
        shl edi, 2
        sub edi, esi
        add edi, edi
        mov ebp, dword [byte edi+eax+012h]
        xor ebx, ebx
        mov edx, ebp
        mov eax, dword [byte esp+010h]
        call lseek_
        lea eax, [byte esp+08h]
        push eax
        mov edx, 2
        mov ecx, ds
        lea ebx, [byte esp+01Ch]
        mov eax, dword [byte esp+014h]
        call _dos_read_
        mov eax, dword [byte esp+018h]
        xor ah, ah
        xor edx, edx
        mov dx, word [byte esp+018h]
        sar edx, 8
        mov dword [byte esp+018h], edx
        cmp ax, 47h
        jne short .5
        lea edx, [byte ebp+06h]
        xor ebx, ebx
        mov eax, dword [byte esp+010h]
        call lseek_
        lea eax, [byte esp+08h]
        push eax
        mov edx, 2
        mov ecx, ds
        lea ebx, [byte esp+010h]
        mov eax, dword [byte esp+014h]
        call _dos_read_
        mov eax, dword [byte esp+0Ch]
        call Swap16
        sub eax, byte 5
        mov dword [byte esp+0Ch], eax
        mov edx, dword [speechbank]
        mov dword [byte edx+edi+016h], eax
        mov dword [esp], eax
        xor ebp, ebp
        mov dword [byte esp+04h], ebp
        fild qword [esp]
        fmul qword [qword_C37B0]
        fdiv qword [qword_C37C0]
        call __CHP
        fistp qword [esp]
        mov edx, dword [speechbank]
        mov eax, dword [esp]
        mov dword [byte edx+edi+01Eh], eax
        mov eax, dword [speechbank]
        mov byte [byte edi+eax+0Dh], 47h
        jmp short .6
.5:
        mov edx, dword [speechbank]
        mov eax, dword [byte edx+edi+01Ah]
        mov dword [byte esp+0Ch], eax
        mov dword [byte edx+edi+016h], eax
        mov dword [esp], eax
        xor ecx, ecx
        mov dword [byte esp+04h], ecx
        fild qword [esp]
        fmul qword [qword_C37B0]
        fdiv qword [qword_C37B8]
        call __CHP
        fistp qword [esp]
        mov edx, dword [speechbank]
        mov eax, dword [esp]
        sub eax, byte 1Ah
        mov dword [byte edx+edi+01Eh], eax
        mov eax, dword [speechbank]
        mov byte [byte edi+eax+0Dh], 0FFh
.6:
        inc esi
.7:
        mov eax, dword [speechbank]
        mov edx, dword [dword eax+03B8Fh]
        sar edx, 10h
        cmp esi, edx
        jl near OpenSpeechBank.4
        mov esi, edx
        jmp short .9
.8:
        mov eax, esi
        shl eax, 2
        add eax, esi
        shl eax, 2
        sub eax, esi
        add eax, eax
        mov edx, dword [speechbank]
        add eax, edx
        call ClearSpeechSlot
        inc esi
.9:
        cmp esi, 190h
        jl short OpenSpeechBank.8
.10:
        add esp, byte 24h
OpenSpeechBank_ret:
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; SpeechSlotSize                               83BC7  95 PC, medium confidence
; Size field (+16h) of slot, 0 for -1
;-----------------------------------------------------------------------------
; C: src/front/announcer/SpeechSlotSize.c
%ifdef CBUILD
%include "c/front/announcer/SpeechSlotSize.inc"
%else
SpeechSlotSize:
        push dword 8
        call __CHK
        push edx
        cmp eax, byte 0FFFFFFFFh
        jne short .1
        xor eax, eax
        pop edx
        ret
.1:
        mov edx, eax
        shl eax, 2
        add eax, edx
        shl eax, 2
        sub eax, edx
        mov edx, dword [speechbank]
        mov eax, dword [byte edx+eax*2+016h]
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ReadSpeechSample                             83BF3  95 PC, medium confidence
; Seeks bank file and reads sample bytes into speech buffer
;-----------------------------------------------------------------------------
; C: src/front/announcer/OpenSpeechBank.c (ReadSpeechSample)
%ifdef CBUILD
%include "c/front/announcer/OpenSpeechBank.ReadSpeechSample.inc"
%else
ReadSpeechSample:
        push dword 38h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 14h
        mov ecx, eax
        mov esi, edx
        shl eax, 2
        add eax, ecx
        shl eax, 2
        sub eax, ecx
        add eax, eax
        mov edx, dword [speechbank]
        add eax, edx
        mov edi, dword [byte eax+01Ah]
        mov edx, dword [dword edx+03B7Ch]
        mov dword [esp], edx
        mov edx, dword [byte eax+012h]
        mov dword [byte esp+0Ch], edx
        mov eax, dword [byte eax+016h]
        mov dword [byte esp+08h], eax
        push esi
        call _os_handle_3
        mov ebp, eax
        add esp, byte 4
        mov esi, eax
        mov eax, dword [byte esp+08h]
        sub eax, edi
        add eax, 1388h
        lea edx, [eax+ebp]
        mov dword [byte esp+010h], edx
        xor ebx, ebx
        mov edx, dword [byte esp+0Ch]
        mov eax, dword [esp]
        call lseek_
        lea eax, [byte esp+04h]
        push eax
        mov ecx, ds
        mov edx, edi
        mov ebx, dword [byte esp+014h]
        mov eax, dword [byte esp+04h]
        call _dos_read_
        push edi
        push ebp
        mov edx, dword [byte esp+018h]
        push edx
        call sub_98028
        add esp, byte 0Ch
        mov ecx, eax
        xor bl, bl
        xor edx, edx
        jmp short .2
.1:
        mov bh, byte [byte edx+esi+05h]
        add bh, bl
        mov byte [edx+esi], bh
        add bl, byte [byte edx+esi+05h]
        inc edx
.2:
        lea eax, [byte ecx-05h]
        cmp edx, eax
        jl short ReadSpeechSample.1
        add esp, byte 14h
        jmp near OpenSpeechBank_ret
%endif ; C
;-----------------------------------------------------------------------------
; LoadSpeechSlot                               83CAE  95 PC, medium confidence
; Places slot after previous one and reads its data
;-----------------------------------------------------------------------------
; C: src/front/announcer/ShutdownSpeech.c (LoadSpeechSlot)
%ifdef CBUILD
%include "c/front/announcer/ShutdownSpeech.LoadSpeechSlot.inc"
%else
LoadSpeechSlot:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        sub esp, byte 8
        mov ebx, eax
        test eax, eax
        jne short .1
        mov edx, dword [speechbank]
        mov edx, dword [dword edx+03B64h]
        jmp short .2
.1:
        lea edx, [byte eax-01h]
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        mov edx, dword [speechbank]
        add eax, edx
        mov edx, dword [byte eax+0Eh]
        add edx, dword [byte eax+016h]
.2:
        mov eax, ebx
        shl eax, 2
        add eax, ebx
        shl eax, 2
        sub eax, ebx
        lea ecx, [eax+eax]
        mov eax, dword [speechbank]
        mov dword [byte ecx+eax+0Eh], edx
        mov eax, ebx
        call ReadSpeechSample
        mov edx, eax
        mov eax, dword [speechbank]
        mov dword [byte ecx+eax+016h], edx
        mov eax, dword [speechbank]
        mov ebx, dword [dword eax+03B70h]
        mov dword [esp], edx
        xor esi, esi
        mov dword [byte esp+04h], esi
        fild qword [esp]
        fmul qword [qword_C37C8]
        fdiv qword [qword_C37D0]
        call __CHP
        fistp qword [esp]
        mov esi, dword [esp]
        sub esi, ebx
        mov dword [byte ecx+eax+01Eh], esi
        mov eax, dword [speechbank]
        mov dword [byte ecx+eax+022h], 1
        mov eax, dword [speechbank]
        add dword [dword eax+03B6Ch], edx
        mov eax, dword [speechbank]
        inc dword [dword eax+03B74h]
        jmp near ReadBE24_ret
%endif ; C
;-----------------------------------------------------------------------------
; PlaceSpeechSlot                                 83D78  95 PC, low confidence
; Places slot after previous one and reads header
;-----------------------------------------------------------------------------
; C: src/front/announcer/ShutdownSpeech.c (PlaceSpeechSlot)
%ifdef CBUILD
%include "c/front/announcer/ShutdownSpeech.PlaceSpeechSlot.inc"
%else
PlaceSpeechSlot:
        push dword 28h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 8
        mov edx, eax
        test eax, eax
        jne short .1
        mov ebp, dword [speechbank]
        mov ebp, dword [dword ebp+03B64h]
        jmp short .2
.1:
        lea esi, [byte eax-01h]
        mov eax, esi
        shl eax, 2
        add eax, esi
        shl eax, 2
        sub eax, esi
        mov esi, dword [speechbank]
        mov ebp, dword [byte esi+eax*2+0Eh]
        add ebp, dword [byte esi+eax*2+016h]
.2:
        mov esi, edx
        shl esi, 2
        add esi, edx
        shl esi, 2
        sub esi, edx
        mov eax, dword [speechbank]
        mov dword [byte eax+esi*2+0Eh], ebp
        mov eax, dword [speechbank]
        mov edi, dword [dword eax+03B7Ch]
        mov edx, dword [byte eax+esi*2+01Ah]
        mov dword [byte esp+04h], edx
        mov edx, dword [byte eax+esi*2+012h]
        xor ebx, ebx
        mov eax, edi
        call lseek_
        mov eax, esp
        push eax
        mov ecx, ds
        mov edx, dword [byte esp+08h]
        mov ebx, ebp
        mov eax, edi
        call _dos_read_
        mov eax, dword [speechbank]
        mov dword [byte eax+esi*2+022h], 1
        mov edx, dword [speechbank]
        mov eax, dword [esp]
        add dword [dword edx+03B6Ch], eax
        mov eax, dword [speechbank]
        inc dword [dword eax+03B74h]
        add esp, byte 8
        jmp near ShutdownSpeech_ret6
%endif ; C
;-----------------------------------------------------------------------------
; StrEqNoCase                                  83E32  95 PC, medium confidence
; Case-insensitive string equality (1 = equal)
;-----------------------------------------------------------------------------
; C: src/front/announcer/StrEqNoCase.c
%ifdef CBUILD
%include "c/front/announcer/StrEqNoCase.inc"
%else
StrEqNoCase:
        push dword 0Ch
        call __CHK
        push ebx
        push ecx
.1:
        cmp byte [eax], 0
        jne short .2
        cmp byte [edx], 0
        je short .3
.2:
        movsx ebx, byte [eax]
        and ebx, 0DFh
        movsx ecx, byte [edx]
        and ecx, 0DFh
        inc eax
        inc edx
        cmp ebx, ecx
        je short StrEqNoCase.1
        xor eax, eax
        pop ecx
        pop ebx
        ret
.3:
        mov eax, 1
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; FindFreeSpeechSlot                           83E6D  95 PC, medium confidence
; First slot from index with state 0, else -1
;-----------------------------------------------------------------------------
; C: src/front/announcer/FindFreeSpeechSlot.c
%ifdef CBUILD
%include "c/front/announcer/FindFreeSpeechSlot.inc"
%else
FindFreeSpeechSlot:
        push dword 0Ch
        call __CHK
        push ebx
        push edx
        mov edx, eax
        mov ebx, dword [speechbank]
        jmp short .3
.1:
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        sub eax, edx
        cmp dword [byte ebx+eax*2+022h], byte 0
        jne short .2
        mov eax, edx
        pop edx
        pop ebx
        ret
.2:
        inc edx
.3:
        cmp edx, 190h
        jl short FindFreeSpeechSlot.1
        mov eax, 0FFFFFFFFh
        pop edx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; FindLoadedSpeechSlot                         83EAC  95 PC, medium confidence
; First slot from index with state 1, else -1
;-----------------------------------------------------------------------------
; C: src/front/announcer/FindLoadedSpeechSlot.c
%ifdef CBUILD
%include "c/front/announcer/FindLoadedSpeechSlot.inc"
%else
FindLoadedSpeechSlot:
        push dword 0Ch
        call __CHK
        push ebx
        push edx
        mov edx, eax
        mov ebx, dword [speechbank]
        jmp short .3
.1:
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        sub eax, edx
        cmp dword [byte ebx+eax*2+022h], byte 1
        jne short .2
        mov eax, edx
        pop edx
        pop ebx
        ret
.2:
        inc edx
.3:
        cmp edx, 190h
        jl short FindLoadedSpeechSlot.1
        mov eax, 0FFFFFFFFh
        pop edx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; FindSpeechSlot                               83EEB  95 PC, medium confidence
; Slot index by sample name, else -1
;-----------------------------------------------------------------------------
; C: src/front/announcer/FindSpeechSlot.c
%ifdef CBUILD
%include "c/front/announcer/FindSpeechSlot.inc"
%else
FindSpeechSlot:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        mov ecx, eax
        xor ebx, ebx
.1:
        mov eax, ebx
        shl eax, 2
        add eax, ebx
        shl eax, 2
        sub eax, ebx
        add eax, eax
        mov edx, dword [speechbank]
        add edx, eax
        mov eax, ecx
        call StrEqNoCase
        test eax, eax
        je short .2
        mov eax, ebx
        pop edx
        pop ecx
        pop ebx
        ret
.2:
        inc ebx
        cmp ebx, 190h
        jl short FindSpeechSlot.1
        mov eax, 0FFFFFFFFh
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SpeechSlotLoaded                             83F35  95 PC, medium confidence
; Slot state == 1
;-----------------------------------------------------------------------------
; C: src/front/announcer/SpeechSlotLoaded.c
%ifdef CBUILD
%include "c/front/announcer/SpeechSlotLoaded.inc"
%else
SpeechSlotLoaded:
        push dword 8
        call __CHK
        push edx
        mov edx, eax
        shl eax, 2
        add eax, edx
        shl eax, 2
        sub eax, edx
        mov edx, dword [speechbank]
        cmp dword [byte edx+eax*2+022h], byte 1
        sete al
        and eax, 0FFh
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; IsSampleRequested                            83F61  95 PC, medium confidence
; Name present in samplereq list
;-----------------------------------------------------------------------------
; C: src/front/announcer/IsSampleRequested.c
%ifdef CBUILD
%include "c/front/announcer/IsSampleRequested.inc"
%else
IsSampleRequested:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov esi, eax
        xor ebx, ebx
        jmp short .3
.1:
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 2
        add eax, ebx
        lea edx, [ecx+eax]
        mov eax, esi
        call StrEqNoCase
        test eax, eax
        je short .2
        mov eax, 1
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.2:
        inc ebx
.3:
        mov ecx, dword [samplereq]
        cmp ebx, dword [dword ecx+0108h]
        jl short IsSampleRequested.1
        xor eax, eax
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; RequestSample                                83FAF  95 PC, medium confidence
; Adds name to samplereq, loads it if not resident
;-----------------------------------------------------------------------------
; C: src/front/announcer/RequestSample.c
%ifdef CBUILD
%include "c/front/announcer/RequestSample.inc"
%else
RequestSample:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov ecx, eax
        call IsSampleRequested
        cmp eax, byte 1
        je short .x
        mov edx, dword [samplereq]
        mov esi, dword [dword edx+0108h]
        mov eax, esi
        shl eax, 2
        sub eax, esi
        shl eax, 2
        add eax, esi
        inc esi
        mov dword [dword edx+0108h], esi
        mov edx, dword [samplereq]
        add eax, edx
        mov ebx, 0Dh
        mov edx, ecx
        call strncpy_
        mov eax, ecx
        call FindSpeechSlot
        mov ecx, eax
        cmp eax, byte 0FFFFFFFFh
        je short .1
        call SpeechSlotLoaded
        test eax, eax
        jne short .1
        mov edx, dword [samplereq]
        mov eax, ecx
        call SpeechSlotSize
        add dword [dword edx+0104h], eax
.1:
        mov eax, dword [samplereq]
        inc dword [dword eax+010Ch]
.x:
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; FreeUnrequestedSamples                       84036  95 PC, medium confidence
; Frees loaded slots no longer requested, updates used size
;-----------------------------------------------------------------------------
; C: src/front/announcer/FreeUnrequestedSamples.c
%ifdef CBUILD
%include "c/front/announcer/FreeUnrequestedSamples.inc"
%else
FreeUnrequestedSamples:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        mov edx, 18Fh
        jmp short .3
.1:
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        sub eax, edx
        lea ebx, [eax+eax]
        mov eax, dword [speechbank]
        add eax, ebx
        mov ecx, dword [byte eax+022h]
        cmp ecx, byte 1
        jne short .2
        call IsSampleRequested
        test eax, eax
        jne short .2
        mov eax, dword [speechbank]
        mov dword [byte ebx+eax+022h], 0
        mov eax, dword [speechbank]
        mov edx, dword [byte ebx+eax+016h]
        sub dword [dword eax+03B6Ch], edx
        mov eax, dword [speechbank]
        mov ebx, ecx
        sub dword [dword eax+03B74h], ecx
        jmp short .4
.2:
        dec edx
.3:
        test edx, edx
        jge short FreeUnrequestedSamples.1
        xor ebx, ebx
.4:
        mov eax, ebx
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; MoveSampleMem                                840A9  95 PC, medium confidence
; Chunked move through speechcopybuf (speechcopylen bytes per step)
;-----------------------------------------------------------------------------
; C: src/front/announcer/OpenSpeechBank.c (MoveSampleMem)
%ifdef CBUILD
%include "c/front/announcer/OpenSpeechBank.MoveSampleMem.inc"
%else
MoveSampleMem:
        push dword 20h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 8
        mov ebp, eax
        mov dword [esp], edx
        mov edi, ebx
.1:
        test edi, edi
        je short .x
        mov edx, dword [speechcopylen]
        cmp edi, edx
        jbe short .2
        mov esi, edx
        jmp short .3
.2:
        mov esi, edi
.3:
        mov ebx, dword [esp]
        push ebx
        call _os_handle_3
        add esp, byte 4
        push esi
        mov ecx, ds
        mov edx, ds
        mov ebx, dword [speechcopybuf]
        mov dword [byte esp+08h], ebx
        mov ebx, eax
        mov eax, dword [byte esp+08h]
        call _fmemmove_
        push ebp
        call _os_handle_3
        add esp, byte 4
        push esi
        mov ecx, ds
        mov ebx, dword [speechcopybuf]
        mov edx, ds
        call _fmemmove_
        add dword [esp], esi
        add ebp, esi
        sub edi, esi
        jmp short MoveSampleMem.1
.x:
        add esp, byte 8
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CompactSpeechSlot                            84125  95 PC, medium confidence
; Moves a slot's data down next to the previous slot
;-----------------------------------------------------------------------------
; C: src/front/announcer/OpenSpeechBank.c (CompactSpeechSlot)
%ifdef CBUILD
%include "c/front/announcer/OpenSpeechBank.CompactSpeechSlot.inc"
%else
CompactSpeechSlot:
        push dword 44h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 2Ch
        mov ecx, eax
        mov ebx, edx
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        sub eax, edx
        mov edx, dword [speechbank]
        mov esi, dword [byte edx+eax*2+0Eh]
        test ecx, ecx
        jne short .1
        mov ebp, dword [dword edx+03B64h]
        jmp short .2
.1:
        lea ebp, [byte ecx-01h]
        mov eax, ebp
        shl eax, 2
        add eax, ebp
        shl eax, 2
        sub eax, ebp
        mov ebp, dword [byte edx+eax*2+0Eh]
        add ebp, dword [byte edx+eax*2+016h]
.2:
        mov eax, ebx
        shl eax, 2
        add eax, ebx
        shl eax, 2
        sub eax, ebx
        add eax, eax
        mov dword [byte esp+028h], eax
        mov ebx, dword [speechbank]
        add ebx, eax
        mov ebx, dword [byte ebx+016h]
        mov edx, esi
        mov eax, ebp
        call MoveSampleMem
        mov edx, ecx
        shl edx, 2
        add edx, ecx
        shl edx, 2
        sub edx, ecx
        add edx, edx
        mov ebx, dword [speechbank]
        lea eax, [ebx+edx]
        mov ecx, 9
        mov edi, esp
        mov esi, eax
        rep movsd
        movsw
        mov esi, dword [byte esp+028h]
        add esi, ebx
        mov ecx, 9
        mov edi, eax
        rep movsd
        movsw
        mov edi, dword [speechbank]
        mov ebx, dword [byte esp+028h]
        add edi, ebx
        mov ecx, 9
        mov esi, esp
        rep movsd
        movsw
        mov eax, dword [speechbank]
        mov dword [byte edx+eax+0Eh], ebp
        mov eax, dword [speechbank]
        add eax, ebx
        mov dword [byte eax+022h], 0
        add esp, byte 2Ch
        jmp near OpenSpeechBank_ret
%endif ; C
;-----------------------------------------------------------------------------
; MakeSampleRoom                               84205  95 PC, medium confidence
; Frees unrequested samples until used + requested fits the limit
;-----------------------------------------------------------------------------
; C: src/front/announcer/MakeSampleRoom.c
%ifdef CBUILD
%include "c/front/announcer/MakeSampleRoom.inc"
%else
MakeSampleRoom:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        xor edx, edx
        xor ecx, ecx
        mov eax, dword [speechbank]
        mov esi, dword [dword eax+03B68h]
        mov ebx, dword [samplereq]
        mov eax, dword [dword eax+03B6Ch]
        add eax, dword [dword ebx+0104h]
        cmp eax, esi
        jbe short .x
.1:
        call FreeUnrequestedSamples
        mov eax, dword [speechbank]
        mov ebx, dword [samplereq]
        mov eax, dword [dword eax+03B6Ch]
        add eax, dword [dword ebx+0104h]
        cmp eax, esi
        jae short .2
        mov ecx, 1
.2:
        test ecx, ecx
        jne short .x
        inc edx
        cmp edx, 190h
        jl short MakeSampleRoom.1
.x:
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; EnsureSampleRoom                             8426F  95 PC, medium confidence
; __CHK wrapper of MakeSampleRoom
;-----------------------------------------------------------------------------
; C: src/front/announcer/ShutdownSpeech.c (EnsureSampleRoom)
%ifdef CBUILD
%include "c/front/announcer/ShutdownSpeech.EnsureSampleRoom.inc"
%else
EnsureSampleRoom:
        push dword 4
        call __CHK
        call MakeSampleRoom
%endif ; C
;-----------------------------------------------------------------------------
; CompactSpeechMem                             8427E  95 PC, medium confidence
; Walks free/loaded slots compacting data
;-----------------------------------------------------------------------------
; C: src/front/announcer/ShutdownSpeech.c (CompactSpeechMem)
%ifdef CBUILD
%include "c/front/announcer/ShutdownSpeech.CompactSpeechMem.inc"
%else
CompactSpeechMem:
        push dword 0Ch
        call __CHK
        push ebx
        push edx
        xor eax, eax
        call FindFreeSpeechSlot
        mov ebx, eax
        cmp eax, byte 0FFFFFFFFh
        je short .2
.1:
        call FindLoadedSpeechSlot
        mov edx, eax
.2:
        cmp edx, byte 0FFFFFFFFh
        je near FreeClip_ret
        mov eax, ebx
        call CompactSpeechSlot
        mov eax, ebx
        call FindFreeSpeechSlot
        mov ebx, eax
        jmp short CompactSpeechMem.1
%endif ; C
;-----------------------------------------------------------------------------
; PenaltyLenClip                               842BA  95 PC, medium confidence
; Picks '2min.cor' / '5min.cor' (or gamemisc.cor) for a penalty length
;-----------------------------------------------------------------------------
; C: src/front/announcer/PenaltyLenClip.c
%ifdef CBUILD
%include "c/front/announcer/PenaltyLenClip.inc"
%else
PenaltyLenClip:
        push dword 14h
        call __CHK
        push ebx
        mov ebx, eax
        mov eax, edx
        cmp ebx, byte 2
        jl short .1
        jle short .4
        cmp ebx, byte 5
        je short .2
        jmp short .4
.1:
        cmp ebx, byte 0FFFFFFFFh
        je short .3
        jmp short .4
.2:
        mov edx, str_5minCor
        jmp short .5
.3:
        push str_Cor
        push str_GamemiscS
        push edx
        call sprintf_
        add esp, byte 0Ch
        pop ebx
        ret
.4:
        mov edx, str_2minCor
.5:
        call strcpy_
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; PlayoffRoundClipD                            84306  95 PC, medium confidence
; Series round clip east/west quad/semd/find, stanleyd.bar
;-----------------------------------------------------------------------------
; C: src/front/announcer/PlayoffRoundClipD.c
%ifdef CBUILD
%include "c/front/announcer/PlayoffRoundClipD.inc"
%else
PlayoffRoundClipD:
        push dword 10h
        call __CHK
        push ecx
        mov ecx, eax
        mov eax, ebx
        cmp edx, byte 2
        jb short .1
        jbe short .5
        cmp edx, byte 3
        je near .9
        pop ecx
        ret
.1:
        cmp edx, byte 1
        jne near .x
        cmp ebx, byte 2
        jb short .2
        jbe short .3
        cmp ebx, byte 3
        je short .4
        pop ecx
        ret
.2:
        cmp ebx, edx
        jne short .x
        push str_EastquadBar
        jmp short .10
.3:
        push str_EastsemdBar
        jmp short .10
.4:
        push str_EastfindBar
        jmp short .10
.5:
        cmp ebx, byte 2
        jb short .6
        jbe short .7
        cmp ebx, byte 3
        je short .8
        pop ecx
        ret
.6:
        cmp ebx, byte 1
        jne short .x
        push str_WestquadBar
        jmp short .10
.7:
        push str_WestsemdBar
        jmp short .10
.8:
        push str_WestfindBar
        jmp short .10
.9:
        push str_StanleydBar
.10:
        push ecx
        call sprintf_
        add esp, byte 8
.x:
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; PlayoffRoundClipU                            8438F  95 PC, medium confidence
; Series round clip east/west quau/semu/finu, stanleyu.bar
;-----------------------------------------------------------------------------
; C: src/front/announcer/PlayoffRoundClipU.c
%ifdef CBUILD
%include "c/front/announcer/PlayoffRoundClipU.inc"
%else
PlayoffRoundClipU:
        push dword 10h
        call __CHK
        push ecx
        mov ecx, eax
        mov eax, ebx
        cmp edx, byte 2
        jb short .1
        jbe short .5
        cmp edx, byte 3
        je near .9
        pop ecx
        ret
.1:
        cmp edx, byte 1
        jne near .x
        cmp ebx, byte 2
        jb short .2
        jbe short .3
        cmp ebx, byte 3
        je short .4
        pop ecx
        ret
.2:
        cmp ebx, edx
        jne short .x
        push str_EastquauBar
        jmp short .10
.3:
        push str_EastsemuBar
        jmp short .10
.4:
        push str_EastfinuBar
        jmp short .10
.5:
        cmp ebx, byte 2
        jb short .6
        jbe short .7
        cmp ebx, byte 3
        je short .8
        pop ecx
        ret
.6:
        cmp ebx, byte 1
        jne short .x
        push str_WestquauBar
        jmp short .10
.7:
        push str_WestsemuBar
        jmp short .10
.8:
        push str_WestfinuBar
        jmp short .10
.9:
        push str_StanleyuBar
.10:
        push ecx
        call sprintf_
        add esp, byte 8
.x:
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; QueueSpeechClip                              84418  95 PC, medium confidence
; Appends clip slot to speechq, loading it into memory if needed
;-----------------------------------------------------------------------------
; C: src/front/announcer/ShutdownSpeech.c (QueueSpeechClip)
%ifdef CBUILD
%include "c/front/announcer/ShutdownSpeech.QueueSpeechClip.inc"
%else
QueueSpeechClip:
        push dword 54h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 38h
        mov edx, eax
        mov eax, dword [speechq]
        mov ecx, dword [byte eax+054h]
        mov dword [byte esp+030h], ecx
        lea ebx, [byte ecx+01h]
        mov dword [byte eax+054h], ebx
        mov eax, edx
        call FindSpeechSlot
        mov ebx, eax
        cmp eax, byte 0FFFFFFFFh
        jne short .2
.1:
        mov edx, dword [speechq]
        xor eax, eax
        dec dword [byte edx+054h]
        jmp near .7
.2:
        call SpeechSlotLoaded
        test eax, eax
        je short .3
        mov eax, dword [speechq]
        mov dword [eax+ecx*4], ebx
        jmp near .6
.3:
        call FindFreeSpeechSlot
        mov edx, eax
        mov dword [byte esp+034h], eax
        cmp eax, byte 0FFFFFFFFh
        je short QueueSpeechClip.1
        shl eax, 2
        add eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        mov dword [byte esp+028h], eax
        mov eax, dword [speechbank]
        mov dword [byte esp+02Ch], eax
        mov ecx, dword [byte esp+028h]
        lea ebp, [eax+ecx]
        mov ecx, 9
        mov edi, esp
        mov esi, ebp
        rep movsd
        movsw
        mov eax, ebx
        shl eax, 2
        add eax, ebx
        shl eax, 2
        sub eax, ebx
        add eax, eax
        mov esi, dword [byte esp+02Ch]
        add esi, eax
        mov ecx, 9
        mov edi, ebp
        rep movsd
        movsw
        mov edi, dword [speechbank]
        add edi, eax
        mov ecx, 9
        mov esi, esp
        rep movsd
        movsw
        mov eax, dword [speechbank]
        mov ebx, dword [byte esp+028h]
        add ebx, eax
        mov ecx, dword [dword eax+03B6Ch]
        add ecx, dword [byte ebx+016h]
        cmp ecx, dword [dword eax+03B68h]
        ja near QueueSpeechClip.1
        cmp byte [byte ebx+0Dh], 47h
        jne short .4
        mov eax, edx
        call LoadSpeechSlot
        jmp short .5
.4:
        mov eax, edx
        call PlaceSpeechSlot
.5:
        mov edx, dword [byte esp+030h]
        shl edx, 2
        mov eax, dword [speechq]
        add eax, edx
        mov edx, dword [byte esp+034h]
        mov dword [eax], edx
.6:
        mov eax, 1
.7:
        add esp, byte 38h
        jmp near ShutdownSpeech_ret6
%endif ; C
;-----------------------------------------------------------------------------
; LoadClipSlot                                 84539  95 PC, medium confidence
; Moves a clip slot into a free slot and loads ('G' type) or places it
;-----------------------------------------------------------------------------
; C: src/front/announcer/ShutdownSpeech.c (LoadClipSlot)
%ifdef CBUILD
%include "c/front/announcer/ShutdownSpeech.LoadClipSlot.inc"
%else
LoadClipSlot:
        push dword 48h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 2Ch
        call FindSpeechSlot
        mov ebx, eax
        cmp eax, byte 0FFFFFFFFh
        jne short .2
.1:
        xor eax, eax
        jmp near .5
.2:
        call SpeechSlotLoaded
        test eax, eax
        jne near .4
        call FindFreeSpeechSlot
        mov edx, eax
        cmp eax, byte 0FFFFFFFFh
        je short LoadClipSlot.1
        mov eax, ebx
        shl eax, 2
        add eax, ebx
        shl eax, 2
        sub eax, ebx
        add eax, eax
        mov dword [byte esp+028h], eax
        mov ebx, dword [speechbank]
        lea ebp, [eax+ebx]
        mov eax, dword [dword ebx+03B6Ch]
        add eax, dword [byte ebp+016h]
        cmp eax, dword [dword ebx+03B68h]
        ja short LoadClipSlot.1
        mov ecx, edx
        mov eax, ecx
        shl eax, 2
        add eax, ecx
        shl eax, 2
        sub eax, ecx
        add eax, eax
        add ebx, eax
        mov ecx, 9
        mov edi, esp
        mov esi, ebx
        rep movsd
        movsw
        mov ecx, 9
        mov edi, ebx
        mov esi, ebp
        rep movsd
        movsw
        mov edi, dword [speechbank]
        add edi, dword [byte esp+028h]
        mov ecx, 9
        mov esi, esp
        rep movsd
        movsw
        mov ebx, dword [speechbank]
        cmp byte [byte ebx+eax+0Dh], 47h
        jne short .3
        mov eax, edx
        call LoadSpeechSlot
        jmp short .4
.3:
        mov eax, edx
        call PlaceSpeechSlot
.4:
        mov eax, 1
.5:
        add esp, byte 2Ch
        jmp near ShutdownSpeech_ret6
%endif ; C
;-----------------------------------------------------------------------------
; SayClip_body                                                    8460F  95 PC
;-----------------------------------------------------------------------------
; C: src/front/announcer/ShutdownSpeech.c (SayClip_body)
%ifdef CBUILD
%include "c/front/announcer/ShutdownSpeech.SayClip_body.inc"
%else
SayClip_body:
        call SpeechIdle
        test eax, eax
        je short .x
        call ResetSpeechQueue
        call ResetSampleReq
        mov eax, dword [speechbank]
        mov dword [dword eax+03B70h], 0
        mov eax, edx
        call RequestSample
        call EnsureSampleRoom
        mov eax, edx
        call QueueSpeechClip
        mov eax, dword [speechq]
        mov dword [byte eax+060h], 1
        mov eax, 1
.x:
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SayScorePeriod                               84657  95 PC, medium confidence
; One-clip announcement from scorperclips table
;-----------------------------------------------------------------------------
; C: src/front/announcer/ShutdownSpeech.c (SayScorePeriod)
%ifdef CBUILD
%include "c/front/announcer/ShutdownSpeech.SayScorePeriod.inc"
%else
SayScorePeriod:
        push dword 8
        call __CHK
        push edx
        mov edx, eax
        cmp dword [speechinit], byte 0
        jne short .1
        xor eax, eax
        pop edx
        ret
.1:
        call SpeechIdle
        test eax, eax
        je short .x
        call ResetSpeechQueue
        call ResetSampleReq
        mov eax, dword [nosplit edx*4+scorperclips]
        call RequestSample
        call EnsureSampleRoom
        mov eax, dword [nosplit edx*4+scorperclips]
        call QueueSpeechClip
        mov eax, dword [speechq]
        mov dword [byte eax+060h], 1
        mov eax, 1
.x:
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SayNhlIntro                                  846B4  95 PC, medium confidence
; Clip 'nhl.int'
;-----------------------------------------------------------------------------
; C: src/front/announcer/ShutdownSpeech.c (SayNhlIntro)
%ifdef CBUILD
%include "c/front/announcer/ShutdownSpeech.SayNhlIntro.inc"
%else
SayNhlIntro:
        push dword 4
        call __CHK
        mov eax, str_NhlInt
        jmp near SayClip
;-----------------------------------------------------------------------------
; SayGoodnight                                 846C8  95 PC, medium confidence
; Clip 'goodnite.int'
;-----------------------------------------------------------------------------
SayGoodnight:
        push dword 4
        call __CHK
        mov eax, str_GoodniteInt
        jmp near SayClip
;-----------------------------------------------------------------------------
; SayLineups                                   846DC  95 PC, medium confidence
; Clip 'lineups.int'
;-----------------------------------------------------------------------------
SayLineups:
        push dword 4
        call __CHK
        mov eax, str_LineupsInt
        jmp near SayClip
;-----------------------------------------------------------------------------
; SayNowBack                                   846F0  95 PC, medium confidence
; Clip 'nowback.int' (SportsDesk)
;-----------------------------------------------------------------------------
SayNowBack:
        push dword 4
        call __CHK
        mov eax, str_NowbackInt
        jmp near SayClip
;-----------------------------------------------------------------------------
; FreeNowBack                                  84704  95 PC, medium confidence
; Unloads 'nowback.int'
;-----------------------------------------------------------------------------
FreeNowBack:
        push dword 4
        call __CHK
        mov eax, str_NowbackInt
        jmp short FreeClip
;-----------------------------------------------------------------------------
; SayBackMoment                                84715  95 PC, medium confidence
; Clip 'backmomt.int' (SportsDesk)
;-----------------------------------------------------------------------------
SayBackMoment:
        push dword 4
        call __CHK
        mov eax, str_BackmomtInt
        jmp near SayClip
;-----------------------------------------------------------------------------
; FreeBackMoment                               84729  95 PC, medium confidence
; Unloads 'backmomt.int'
;-----------------------------------------------------------------------------
FreeBackMoment:
        push dword 4
        call __CHK
        mov eax, str_BackmomtInt
        jmp short FreeClip
;-----------------------------------------------------------------------------
; SayCoachClip                                 8473A  95 PC, medium confidence
; Clip 'coachclp.int' (coach screen)
;-----------------------------------------------------------------------------
SayCoachClip:
        push dword 4
        call __CHK
        mov eax, str_CoachclpInt
        jmp near SayClip
;-----------------------------------------------------------------------------
; FreeCoachClip                                8474E  95 PC, medium confidence
; Unloads 'coachclp.int'
;-----------------------------------------------------------------------------
FreeCoachClip:
        push dword 4
        call __CHK
        mov eax, str_CoachclpInt
;-----------------------------------------------------------------------------
; FreeClip                                     8475D  95 PC, medium confidence
; Marks a loaded clip slot free and recomputes used memory
;-----------------------------------------------------------------------------
FreeClip:
        push dword 0Ch
        call __CHK
        push ebx
        push edx
        call FindSpeechSlot
        cmp eax, byte 0FFFFFFFFh
        je short FreeClip_ret
        mov edx, eax
        shl eax, 2
        add eax, edx
        shl eax, 2
        sub eax, edx
        lea edx, [eax+eax]
        mov eax, dword [speechbank]
        add eax, edx
        mov ebx, dword [byte eax+022h]
        cmp ebx, byte 1
        jne short FreeClip_ret
        mov dword [byte eax+022h], 0
        mov eax, dword [speechbank]
        mov edx, dword [byte edx+eax+016h]
        sub dword [dword eax+03B6Ch], edx
        mov eax, dword [speechbank]
        sub dword [dword eax+03B74h], ebx
        call EnsureSampleRoom
FreeClip_ret:
        pop edx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; SayElseNhl                                   847BA  95 PC, medium confidence
; Clip 'elsenhl.int'
;-----------------------------------------------------------------------------
SayElseNhl:
        push dword 4
        call __CHK
        mov eax, str_ElsenhlInt
        jmp near SayClip
%endif ; C
;-----------------------------------------------------------------------------
; SayHighlightIntro                            847CE  95 PC, medium confidence
; 'takeynow' / 'highlite' / 'of' / 'gamebtwn' + team rnk/awa/hom clips
;-----------------------------------------------------------------------------
; C: src/front/announcer/ShutdownSpeech.c (SayHighlightIntro)
%ifdef CBUILD
%include "c/front/announcer/ShutdownSpeech.SayHighlightIntro.inc"
%else
SayHighlightIntro:
        push dword 48h
        call __CHK
        push ecx
        sub esp, byte 30h
        mov ecx, eax
        cmp dword [speechinit], byte 0
        jne short .1
        xor eax, eax
        add esp, byte 30h
        pop ecx
        ret
.1:
        call SpeechIdle
        test eax, eax
        je near .x
        mov eax, dword [speechbank]
        mov dword [dword eax+03B70h], 0
        push str_Rnk
        push ecx
        push str_SS5
        lea eax, [byte esp+02Ch]
        push eax
        call sprintf_
        add esp, byte 10h
        push str_Awa
        push edx
        push str_SS5
        lea eax, [byte esp+01Ch]
        push eax
        call sprintf_
        add esp, byte 10h
        push str_Hom
        push ebx
        push str_SS5
        lea eax, [byte esp+0Ch]
        push eax
        call sprintf_
        add esp, byte 10h
        call ResetSpeechQueue
        call ResetSampleReq
        mov eax, str_TakeynowBar
        call RequestSample
        lea eax, [byte esp+020h]
        call RequestSample
        mov eax, str_HighliteBar
        call RequestSample
        mov eax, str_OfBar
        call RequestSample
        mov eax, str_GamebtwnBar
        call RequestSample
        lea eax, [byte esp+010h]
        call RequestSample
        mov eax, str_AndBar
        call RequestSample
        mov eax, esp
        call RequestSample
        call EnsureSampleRoom
        mov eax, str_TakeynowBar
        call QueueSpeechClip
        lea eax, [byte esp+020h]
        call QueueSpeechClip
        mov eax, str_HighliteBar
        call QueueSpeechClip
        mov eax, str_OfBar
        call QueueSpeechClip
        mov eax, str_GamebtwnBar
        call QueueSpeechClip
        lea eax, [byte esp+010h]
        call QueueSpeechClip
        mov eax, str_AndBar
        call QueueSpeechClip
        mov eax, esp
        call QueueSpeechClip
        mov eax, dword [speechq]
        mov dword [byte eax+060h], 1
        mov eax, 1
.x:
        add esp, byte 30h
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SayPlayoffResult                             8490D  95 PC, medium confidence
; 'gamenum' + round clip + 'overtime' / 'havewon' sentence
;-----------------------------------------------------------------------------
; C: src/front/announcer/ShutdownSpeech.c (SayPlayoffResult)
%ifdef CBUILD
%include "c/front/announcer/ShutdownSpeech.SayPlayoffResult.inc"
%else
SayPlayoffResult:
        push dword 64h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 40h
        mov ebp, eax
        mov esi, edx
        mov edi, ebx
        cmp dword [speechinit], byte 0
        jne short .1
        xor eax, eax
        jmp near .x
.1:
        call SpeechIdle
        test eax, eax
        je near .x
        mov eax, dword [speechbank]
        mov dword [dword eax+03B70h], 0
        push str_Awa
        push ebp
        push str_SS5
        lea eax, [byte esp+03Ch]
        push eax
        call sprintf_
        add esp, byte 10h
        mov ebx, 0Ah
        lea edx, [byte esp+020h]
        mov eax, esi
        call itoa_
        push str_Bar
        lea eax, [byte esp+024h]
        push eax
        push str_Gamenum
        push str_SSS
        lea eax, [byte esp+010h]
        push eax
        call sprintf_
        add esp, byte 14h
        mov ebx, ecx
        mov edx, edi
        lea eax, [byte esp+010h]
        call PlayoffRoundClipD
        call ResetSampleReq
        call ResetSpeechQueue
        cmp dword [byte esp+050h], byte 0
        je short .2
        mov eax, str_OvertimeBar
        call RequestSample
.2:
        lea eax, [byte esp+030h]
        call RequestSample
        mov eax, str_HavewonBar
        call RequestSample
        cmp dword [byte esp+054h], byte 0
        jne short .3
        mov eax, str_GamenumBar
        call RequestSample
        mov eax, esp
        call RequestSample
        mov eax, str_OfBar
        call RequestSample
.3:
        lea eax, [byte esp+010h]
        call RequestSample
        call EnsureSampleRoom
        cmp dword [byte esp+050h], byte 0
        je short .4
        mov eax, str_OvertimeBar
        call QueueSpeechClip
.4:
        lea eax, [byte esp+030h]
        call QueueSpeechClip
        mov eax, str_HavewonBar
        call QueueSpeechClip
        cmp dword [byte esp+054h], byte 0
        jne short .5
        mov eax, str_GamenumBar
        call QueueSpeechClip
        mov eax, esp
        call QueueSpeechClip
        mov eax, str_OfBar
        call QueueSpeechClip
.5:
        lea eax, [byte esp+010h]
        call QueueSpeechClip
        mov eax, dword [speechq]
        mov dword [byte eax+060h], 1
        mov eax, 1
.x:
        add esp, byte 40h
        pop ebp
        pop edi
        pop esi
        ret 8
%endif ; C
;-----------------------------------------------------------------------------
; SayTheGame                                   84A6C  95 PC, medium confidence
; Clip 'thegame.bar'
;-----------------------------------------------------------------------------
; C: src/front/announcer/ShutdownSpeech.c (SayTheGame)
%ifdef CBUILD
%include "c/front/announcer/ShutdownSpeech.SayTheGame.inc"
%else
SayTheGame:
        push dword 4
        call __CHK
        mov eax, str_ThegameBar
        jmp short SayClip
%endif ; C
;-----------------------------------------------------------------------------
; SayScoringPeriod                             84A7D  95 PC, medium confidence
; Picks scorNper / scorNotp / scortotp / thegame clip by period and overtime
;-----------------------------------------------------------------------------
; C: src/front/announcer/ShutdownSpeech.c (SayScoringPeriod)
%ifdef CBUILD
%include "c/front/announcer/ShutdownSpeech.SayScoringPeriod.inc"
%else
SayScoringPeriod:
        push dword 4
        call __CHK
        test ebx, ebx
        je short .1
        mov eax, str_ThegameBar
        jmp short SayClip
.1:
        test edx, edx
        je short SayScoringPeriod_reg
        cmp eax, byte 2
        jb short .2
        jbe short SayScoringPeriod_ot2
        cmp eax, byte 3
        je short SayScoringPeriod_ot3
        jmp short SayScoringPeriod_ott
.2:
        cmp eax, byte 1
        jne short SayScoringPeriod_ott
        mov eax, str_Scor1otpBar
%endif ; C
;-----------------------------------------------------------------------------
; SayClip                                      84AAE  95 PC, medium confidence
; Single-clip announcement (reset queue, request, ensure room, queue, start)
;-----------------------------------------------------------------------------
; C: src/front/announcer/ShutdownSpeech.c (SayClip)
%ifdef CBUILD
%include "c/front/announcer/ShutdownSpeech.SayClip.inc"
%else
SayClip:
        push dword 8
        call __CHK
        push edx
        mov edx, eax
        cmp dword [speechinit], byte 0
        jne near SayClip_body
        xor eax, eax
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SayScoringPeriod_ot2                                            84ACC  95 PC
;-----------------------------------------------------------------------------
; C: src/front/announcer/ShutdownSpeech.c (SayScoringPeriod_ot2)
%ifdef CBUILD
%include "c/front/announcer/ShutdownSpeech.SayScoringPeriod_ot2.inc"
%else
SayScoringPeriod_ot2:
        mov eax, str_Scor2otpBar
        jmp short SayClip
;-----------------------------------------------------------------------------
; SayScoringPeriod_ot3                                            84AD3  95 PC
;-----------------------------------------------------------------------------
SayScoringPeriod_ot3:
        mov eax, str_Scor3otpBar
        jmp short SayClip
;-----------------------------------------------------------------------------
; SayScoringPeriod_ott                                            84ADA  95 PC
;-----------------------------------------------------------------------------
SayScoringPeriod_ott:
        mov eax, str_ScortotpBar
        jmp short SayClip
;-----------------------------------------------------------------------------
; SayScoringPeriod_reg                                            84AE1  95 PC
;-----------------------------------------------------------------------------
SayScoringPeriod_reg:
        cmp eax, byte 2
        jb short .1
        jbe short .2
        cmp eax, byte 3
        je short .3
        xor eax, eax
        ret
.1:
        cmp eax, byte 1
        jne short .4
        mov eax, str_Scor1perBar
        jmp short SayClip
.2:
        mov eax, str_Scor2perBar
        jmp short SayClip
.3:
        mov eax, str_Scor3perBar
        jmp short SayClip
.4:
        xor eax, eax
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SayTonightIntro                              84B0D  95 PC, medium confidence
; 'easports' / 'tonight' / 'gamebtwn' / 'and' + team clips
;-----------------------------------------------------------------------------
; C: src/front/announcer/SayTonightIntro.c
%ifdef CBUILD
%include "c/front/announcer/SayTonightIntro.inc"
%else
SayTonightIntro:
        push dword 48h
        call __CHK
        push ecx
        sub esp, byte 30h
        mov ecx, eax
        cmp dword [speechinit], byte 0
        jne short .1
        xor eax, eax
        add esp, byte 30h
        pop ecx
        ret
.1:
        call SpeechIdle
        test eax, eax
        je near .x
        mov eax, dword [speechbank]
        mov dword [dword eax+03B70h], 0
        push str_Rnk
        push ecx
        push str_SS5
        lea eax, [byte esp+02Ch]
        push eax
        call sprintf_
        add esp, byte 10h
        push str_Awa
        push edx
        push str_SS5
        lea eax, [byte esp+01Ch]
        push eax
        call sprintf_
        add esp, byte 10h
        push str_Hom
        push ebx
        push str_SS5
        lea eax, [byte esp+0Ch]
        push eax
        call sprintf_
        add esp, byte 10h
        call ResetSpeechQueue
        call ResetSampleReq
        mov eax, str_TonightBar
        call RequestSample
        lea eax, [byte esp+020h]
        call RequestSample
        mov eax, str_EasportsBar
        call RequestSample
        mov eax, str_GamebtwnBar
        call RequestSample
        lea eax, [byte esp+010h]
        call RequestSample
        mov eax, str_AndBar
        call RequestSample
        mov eax, esp
        call RequestSample
        call EnsureSampleRoom
        mov eax, str_TonightBar
        call QueueSpeechClip
        lea eax, [byte esp+020h]
        call QueueSpeechClip
        mov eax, str_EasportsBar
        call QueueSpeechClip
        mov eax, str_GamebtwnBar
        call QueueSpeechClip
        lea eax, [byte esp+010h]
        call QueueSpeechClip
        mov eax, str_AndBar
        call QueueSpeechClip
        mov eax, esp
        call QueueSpeechClip
        mov eax, dword [speechq]
        mov dword [byte eax+060h], 1
        mov eax, 1
.x:
        add esp, byte 30h
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SayPlayoffTonight                            84C38  95 PC, medium confidence
; 'tonight' / 'between' / 'gamenum' + round clip + teams
;-----------------------------------------------------------------------------
; C: src/front/announcer/SayPlayoffTonight.c
%ifdef CBUILD
%include "c/front/announcer/SayPlayoffTonight.inc"
%else
SayPlayoffTonight:
        push dword 7Ch
        call __CHK
        push esi
        sub esp, byte 60h
        mov esi, eax
        cmp dword [speechinit], byte 0
        jne short .1
        xor eax, eax
        jmp near .x
.1:
        call SpeechIdle
        test eax, eax
        je near .x
        mov eax, dword [speechbank]
        mov dword [dword eax+03B70h], 0
        push str_Rnk
        push esi
        push str_SS5
        lea eax, [byte esp+04Ch]
        push eax
        call sprintf_
        add esp, byte 10h
        push str_Awa
        push edx
        push str_SS5
        lea eax, [byte esp+05Ch]
        push eax
        call sprintf_
        add esp, byte 10h
        push str_Hom
        push ebx
        push str_SS5
        lea eax, [byte esp+01Ch]
        push eax
        call sprintf_
        add esp, byte 10h
        mov ebx, 0Ah
        lea edx, [byte esp+030h]
        mov eax, ecx
        call itoa_
        push str_Bar
        lea eax, [byte esp+034h]
        push eax
        push str_Gamenum
        push str_SSS
        lea eax, [byte esp+030h]
        push eax
        call sprintf_
        add esp, byte 14h
        mov ebx, dword [byte esp+06Ch]
        mov edx, dword [byte esp+068h]
        mov eax, esp
        call PlayoffRoundClipU
        call ResetSpeechQueue
        call ResetSampleReq
        mov eax, str_TonightBar
        call RequestSample
        lea eax, [byte esp+040h]
        call RequestSample
        mov eax, str_EasportsBar
        call RequestSample
        lea eax, [byte esp+020h]
        call RequestSample
        mov eax, str_OfBar
        call RequestSample
        mov eax, esp
        call RequestSample
        mov eax, str_BetweenBar
        call RequestSample
        lea eax, [byte esp+050h]
        call RequestSample
        mov eax, str_AndBar
        call RequestSample
        lea eax, [byte esp+010h]
        call RequestSample
        call EnsureSampleRoom
        mov eax, str_TonightBar
        call QueueSpeechClip
        lea eax, [byte esp+040h]
        call QueueSpeechClip
        mov eax, str_EasportsBar
        call QueueSpeechClip
        lea eax, [byte esp+020h]
        call QueueSpeechClip
        mov eax, str_OfBar
        call QueueSpeechClip
        mov eax, esp
        call QueueSpeechClip
        mov eax, str_BetweenBar
        call QueueSpeechClip
        lea eax, [byte esp+050h]
        call QueueSpeechClip
        mov eax, str_AndBar
        call QueueSpeechClip
        lea eax, [byte esp+010h]
        call QueueSpeechClip
        mov eax, dword [speechq]
        mov dword [byte eax+060h], 1
        mov eax, 1
.x:
        add esp, byte 60h
        pop esi
        ret 8
%endif ; C
;-----------------------------------------------------------------------------
; RequestTimeClips                             84DDD  95 PC, medium confidence
; Requests 'at', minute / second number clips for a game time
;-----------------------------------------------------------------------------
; C: src/front/announcer/RequestTimeClips.c
%ifdef CBUILD
%include "c/front/announcer/RequestTimeClips.inc"
%else
RequestTimeClips:
        push dword 38h
        call __CHK
        push ebx
        sub esp, byte 20h
        mov ebx, eax
        push str_Num
        push eax
        push str_DS
        lea eax, [byte esp+01Ch]
        push eax
        call sprintf_
        add esp, byte 10h
        push str_Num
        push edx
        push str_02dS
        lea eax, [byte esp+0Ch]
        push eax
        call sprintf_
        add esp, byte 10h
        mov eax, str_AtCor
        call RequestSample
        mov eax, str_PauseCor
        call RequestSample
        test ebx, ebx
        je short .4
        test edx, edx
        jne short .2
        cmp ebx, byte 1
        jne short .1
        mov eax, str_1minuteCor
        jmp short .3
.1:
        lea eax, [byte esp+010h]
        call RequestSample
        mov eax, str_MinutesCor
        jmp short .3
.2:
        lea eax, [byte esp+010h]
.3:
        call RequestSample
.4:
        cmp edx, byte 1
        jne short .6
        test ebx, ebx
        jne short .5
        mov eax, str_1secondCor
        jmp short .8
.5:
        mov eax, esp
        jmp short .8
.6:
        test edx, edx
        jle short .x
        test ebx, ebx
        jne short .7
        push str_Num
        push edx
        push str_DS
        lea eax, [byte esp+0Ch]
        push eax
        call sprintf_
        add esp, byte 10h
        mov eax, esp
        call RequestSample
        mov eax, str_SecondsCor
        jmp short .8
.7:
        mov eax, esp
.8:
        call RequestSample
.x:
        add esp, byte 20h
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; QueueTimeClips                               84EAC  95 PC, medium confidence
; Queues the same time clips
;-----------------------------------------------------------------------------
; C: src/front/announcer/QueueTimeClips.c
%ifdef CBUILD
%include "c/front/announcer/QueueTimeClips.inc"
%else
QueueTimeClips:
        push dword 38h
        call __CHK
        push ebx
        sub esp, byte 20h
        mov ebx, eax
        push str_Num
        push eax
        push str_DS
        lea eax, [byte esp+01Ch]
        push eax
        call sprintf_
        add esp, byte 10h
        push str_Num
        push edx
        push str_02dS
        lea eax, [byte esp+0Ch]
        push eax
        call sprintf_
        add esp, byte 10h
        mov eax, str_AtCor
        call QueueSpeechClip
        mov eax, str_PauseCor
        call QueueSpeechClip
        test ebx, ebx
        je short .4
        test edx, edx
        jne short .2
        cmp ebx, byte 1
        jne short .1
        mov eax, str_1minuteCor
        jmp short .3
.1:
        lea eax, [byte esp+010h]
        call QueueSpeechClip
        mov eax, str_MinutesCor
        jmp short .3
.2:
        lea eax, [byte esp+010h]
.3:
        call QueueSpeechClip
.4:
        cmp edx, byte 1
        jne short .6
        test ebx, ebx
        jne short .5
        mov eax, str_1secondCor
        jmp short .8
.5:
        mov eax, esp
        jmp short .8
.6:
        test edx, edx
        jle short .x
        test ebx, ebx
        jne short .7
        push str_Num
        push edx
        push str_DS
        lea eax, [byte esp+0Ch]
        push eax
        call sprintf_
        add esp, byte 10h
        mov eax, esp
        call QueueSpeechClip
        mov eax, str_SecondsCor
        jmp short .8
.7:
        mov eax, esp
.8:
        call QueueSpeechClip
.x:
        add esp, byte 20h
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SayPenalty                                   84F7B  95 PC, medium confidence
; Team, penalty type, 'pennum' / 'pensnum', length and time
;-----------------------------------------------------------------------------
; C: src/front/announcer/SayPenalty.c
%ifdef CBUILD
%include "c/front/announcer/SayPenalty.inc"
%else
SayPenalty:
        push dword 60h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 40h
        mov esi, eax
        mov edi, dword [byte esp+050h]
        mov ebp, dword [byte esp+054h]
        mov eax, dword [speechinit]
        test eax, eax
        je near .x
        call SpeechIdle
        test eax, eax
        je near .x
        mov eax, dword [speechbank]
        mov dword [dword eax+03B70h], 1Ah
        push str_Tea
        push esi
        push str_SS5
        lea eax, [byte esp+0Ch]
        push eax
        call sprintf_
        add esp, byte 10h
        push str_Num
        push edx
        push str_DS
        lea eax, [byte esp+03Ch]
        push eax
        call sprintf_
        add esp, byte 10h
        lea edx, [byte esp+020h]
        mov eax, ebx
        call PenaltyLenClip
        push str_Pen
        push ecx
        push str_SS5
        lea eax, [byte esp+01Ch]
        push eax
        call sprintf_
        add esp, byte 10h
        call ResetSampleReq
        call ResetSpeechQueue
        mov eax, str_OneleftCor
        call RequestSample
        mov edx, dword [byte esp+058h]
        cmp edx, byte 1
        jne short .2
        mov eax, esp
        call RequestSample
        cmp edx, dword [byte esp+05Ch]
        jge short .1
        mov eax, str_PensnumCor
        jmp short .3
.1:
        mov eax, str_PennumCor
        jmp short .3
.2:
        mov eax, str_AndnumCor
.3:
        call RequestSample
        lea eax, [byte esp+030h]
        call RequestSample
        mov eax, str_PauseCor
        call RequestSample
        lea eax, [byte esp+020h]
        call RequestSample
        lea eax, [byte esp+010h]
        call RequestSample
        mov eax, str_PauseCor
        call RequestSample
        cmp dword [byte esp+060h], byte 0
        je short .4
        mov edx, ebp
        mov eax, edi
        call RequestTimeClips
.4:
        call EnsureSampleRoom
        mov esi, dword [byte esp+058h]
        cmp esi, byte 1
        jne short .6
        mov eax, esp
        call QueueSpeechClip
        cmp esi, dword [byte esp+05Ch]
        jge short .5
        mov eax, str_PensnumCor
        jmp short .7
.5:
        mov eax, str_PennumCor
        jmp short .7
.6:
        mov eax, str_AndnumCor
.7:
        call QueueSpeechClip
        lea eax, [byte esp+030h]
        call QueueSpeechClip
        mov eax, str_PauseCor
        call QueueSpeechClip
        lea eax, [byte esp+020h]
        call QueueSpeechClip
        lea eax, [byte esp+010h]
        call QueueSpeechClip
        mov eax, str_PauseCor
        call QueueSpeechClip
        cmp dword [byte esp+060h], byte 0
        je short .8
        mov edx, ebp
        mov eax, edi
        call QueueTimeClips
.8:
        mov eax, dword [speechq]
        mov dword [byte eax+060h], 1
        mov eax, 1
.x:
        add esp, byte 40h
        pop ebp
        pop edi
        pop esi
        ret 14h
%endif ; C
;-----------------------------------------------------------------------------
; SayPenaltyShot                               8511E  95 PC, medium confidence
; Team + 'penshot' + time
;-----------------------------------------------------------------------------
; C: src/front/announcer/SayPenaltyShot.c
%ifdef CBUILD
%include "c/front/announcer/SayPenaltyShot.inc"
%else
SayPenaltyShot:
        push dword 38h
        call __CHK
        push esi
        sub esp, byte 20h
        mov esi, eax
        cmp dword [speechinit], byte 0
        jne short .1
        xor eax, eax
        add esp, byte 20h
        pop esi
        ret
.1:
        call SpeechIdle
        test eax, eax
        je near .x
        mov eax, dword [speechbank]
        mov dword [dword eax+03B70h], 1Ah
        push str_Tea
        push esi
        push str_SS5
        lea eax, [byte esp+01Ch]
        push eax
        call sprintf_
        add esp, byte 10h
        push str_Num
        push edx
        push str_DS
        lea eax, [byte esp+0Ch]
        push eax
        call sprintf_
        add esp, byte 10h
        call ResetSampleReq
        call ResetSpeechQueue
        mov eax, str_OneleftCor
        call RequestSample
        lea eax, [byte esp+010h]
        call RequestSample
        mov eax, str_PenshotCor
        call RequestSample
        mov eax, esp
        call RequestSample
        mov eax, str_PauseCor
        call RequestSample
        mov edx, ecx
        mov eax, ebx
        call RequestTimeClips
        call EnsureSampleRoom
        lea eax, [byte esp+010h]
        call QueueSpeechClip
        mov eax, str_PenshotCor
        call QueueSpeechClip
        mov eax, esp
        call QueueSpeechClip
        mov eax, str_PauseCor
        call QueueSpeechClip
        mov edx, ecx
        mov eax, ebx
        call QueueTimeClips
        mov eax, dword [speechq]
        mov dword [byte eax+060h], 1
        mov eax, 1
.x:
        add esp, byte 20h
        pop esi
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SayPlayerNumber                              85213  95 PC, medium confidence
; Team 'frm' clip + 'number' + '%d.num'
;-----------------------------------------------------------------------------
; C: src/front/announcer/SayPlayerNumber.c
%ifdef CBUILD
%include "c/front/announcer/SayPlayerNumber.inc"
%else
SayPlayerNumber:
        push dword 4Ch
        call __CHK
        push ecx
        push esi
        sub esp, byte 30h
        mov ecx, eax
        mov esi, ebx
        cmp dword [speechinit], byte 0
        jne short .1
        xor eax, eax
        jmp near .x
.1:
        call SpeechIdle
        test eax, eax
        je near .x
        mov eax, dword [speechbank]
        mov dword [dword eax+03B70h], 1Ah
        push str_Frm
        push ecx
        push str_SS5
        lea eax, [byte esp+02Ch]
        push eax
        call sprintf_
        add esp, byte 10h
        mov edx, dword [nosplit edx*4+str_Cor2]
        mov ebx, 0Dh
        mov eax, esp
        call strncpy_
        push str_Num
        push esi
        push str_DS
        lea eax, [byte esp+01Ch]
        push eax
        call sprintf_
        add esp, byte 10h
        call ResetSampleReq
        call ResetSpeechQueue
        mov eax, str_OneleftCor
        call RequestSample
        mov eax, esp
        call RequestSample
        lea eax, [byte esp+020h]
        call RequestSample
        mov eax, str_PauseCor
        call RequestSample
        mov eax, str_NumberCor
        call RequestSample
        lea eax, [byte esp+010h]
        call RequestSample
        call EnsureSampleRoom
        mov eax, esp
        call QueueSpeechClip
        lea eax, [byte esp+020h]
        call QueueSpeechClip
        mov eax, str_PauseCor
        call QueueSpeechClip
        mov eax, str_NumberCor
        call QueueSpeechClip
        lea eax, [byte esp+010h]
        call QueueSpeechClip
        mov eax, dword [speechq]
        mov dword [byte eax+060h], 1
        mov eax, 1
.x:
        add esp, byte 30h
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SayGoal                                      8531F  95 PC, medium confidence
; Team, 'goalnum', 'asstnum' / 'andnum', time
;-----------------------------------------------------------------------------
; C: src/front/announcer/SayGoal.c
%ifdef CBUILD
%include "c/front/announcer/SayGoal.inc"
%else
SayGoal:
        push dword 5Ch
        call __CHK
        push esi
        push ebp
        sub esp, byte 40h
        mov esi, eax
        cmp dword [speechinit], byte 0
        jne short .1
        xor eax, eax
        jmp near .x
.1:
        call SpeechIdle
        test eax, eax
        je near .x
        mov eax, dword [speechbank]
        mov dword [dword eax+03B70h], 1Ah
        push str_Tea
        push esi
        push str_SS5
        lea eax, [byte esp+03Ch]
        push eax
        call sprintf_
        add esp, byte 10h
        push str_Num
        push ebx
        push str_DS
        lea eax, [byte esp+0Ch]
        push eax
        call sprintf_
        add esp, byte 10h
        push str_Num
        push ecx
        push str_DS
        lea eax, [byte esp+02Ch]
        push eax
        call sprintf_
        add esp, byte 10h
        push str_Num
        mov ebp, dword [byte esp+050h]
        push ebp
        push str_DS
        lea eax, [byte esp+01Ch]
        push eax
        call sprintf_
        add esp, byte 10h
        call ResetSampleReq
        call ResetSpeechQueue
        mov eax, str_OneleftCor
        call RequestSample
        lea eax, [byte esp+030h]
        call RequestSample
        mov eax, str_GoalnumCor
        call RequestSample
        mov eax, esp
        call RequestSample
        test edx, edx
        jle short .2
        mov eax, str_PauseCor
        call RequestSample
        mov eax, str_AsstnumCor
        call RequestSample
        lea eax, [byte esp+020h]
        call RequestSample
.2:
        cmp edx, byte 1
        jle short .3
        mov eax, str_PauseCor
        call RequestSample
        mov eax, str_AndnumCor
        call RequestSample
        lea eax, [byte esp+010h]
        call RequestSample
.3:
        call EnsureSampleRoom
        lea eax, [byte esp+030h]
        call QueueSpeechClip
        mov eax, str_GoalnumCor
        call QueueSpeechClip
        mov eax, esp
        call QueueSpeechClip
        test edx, edx
        jle short .4
        mov eax, str_PauseCor
        call QueueSpeechClip
        mov eax, str_AsstnumCor
        call QueueSpeechClip
        lea eax, [byte esp+020h]
        call QueueSpeechClip
.4:
        cmp edx, byte 1
        jle short .5
        mov eax, str_PauseCor
        call QueueSpeechClip
        mov eax, str_AndnumCor
        call QueueSpeechClip
        lea eax, [byte esp+010h]
        call QueueSpeechClip
.5:
        mov eax, dword [speechq]
        mov dword [byte eax+060h], 1
        mov eax, 1
.x:
        add esp, byte 40h
        pop ebp
        pop esi
        ret 4
%endif ; C
;-----------------------------------------------------------------------------
; SayOneMinuteLeft                             854AC  95 PC, medium confidence
; Clip 'oneleft.cor', sets CCC98
;-----------------------------------------------------------------------------
; C: src/front/announcer/SayOneMinuteLeft.c
%ifdef CBUILD
%include "c/front/announcer/SayOneMinuteLeft.inc"
%else
SayOneMinuteLeft:
        push dword 8
        call __CHK
        push ebx
        cmp dword [speechinit], byte 0
        jne short .1
        xor eax, eax
        pop ebx
        ret
.1:
        call SpeechIdle
        test eax, eax
        je short .x
        call ResetSampleReq
        call ResetSpeechQueue
        mov eax, str_OneleftCor
        call RequestSample
        call EnsureSampleRoom
        mov eax, str_OneleftCor
        call QueueSpeechClip
        mov ebx, 1
        mov dword [oneminsaid], ebx
        mov eax, dword [speechq]
        mov dword [byte eax+060h], ebx
        mov eax, ebx
.x:
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; OpenAnnouncerBank                            85507  95 PC, medium confidence
; Opens XBRUCE2.VIV speech bank
;-----------------------------------------------------------------------------
; C: src/front/announcer/OpenAnnouncerBank.c
%ifdef CBUILD
%include "c/front/announcer/OpenAnnouncerBank.inc"
%else
OpenAnnouncerBank:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        sub esp, byte 10h
        cmp dword [speechinit], byte 0
        jne short .1
        xor eax, eax
        jmp short .x
.1:
        call SpeechIdle
        test eax, eax
        je short .x
        call ResetSampleReq
        call ResetSpeechQueue
        mov ecx, str_VIV
        mov ebx, str_XBRUCE2
        cmp byte [fileoncd+01C0h], 1
        jne short .2
        mov edx, dword [cddriveptr]
        jmp short .3
.2:
        xor edx, edx
.3:
        mov eax, esp
        call MakePath
        xor edx, edx
        mov eax, esp
        call OpenSpeechBank
        mov eax, 1
.x:
        add esp, byte 10h
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; QueuePenaltyType                             85570  95 PC, medium confidence
; Requests / queues penalty type clip from penaltyclips
;-----------------------------------------------------------------------------
; C: src/front/announcer/QueuePenaltyType.c
%ifdef CBUILD
%include "c/front/announcer/QueuePenaltyType.inc"
%else
QueuePenaltyType:
        push dword 28h
        call __CHK
        push edx
        sub esp, byte 10h
        mov eax, dword [speechbank]
        mov edx, dword [dword eax+03B68h]
        sub edx, dword [dword eax+03B6Ch]
        cmp edx, 186A0h
        jbe short .3
        call ResetSampleReq
        call ResetSpeechQueue
        xor edx, edx
.1:
        push str_Num
        push edx
        push str_DS
        lea eax, [byte esp+0Ch]
        push eax
        call sprintf_
        add esp, byte 10h
        mov eax, esp
        call RequestSample
        inc edx
        cmp edx, byte 0Ah
        jl short QueuePenaltyType.1
        xor edx, edx
.2:
        push str_Num
        push edx
        push str_DS
        lea eax, [byte esp+0Ch]
        push eax
        call sprintf_
        add esp, byte 10h
        mov eax, esp
        call QueueSpeechClip
        inc edx
        cmp edx, byte 0Ah
        jl short QueuePenaltyType.2
.3:
        mov eax, dword [speechbank]
        mov edx, dword [dword eax+03B68h]
        sub edx, dword [dword eax+03B6Ch]
        cmp edx, 186A0h
        jbe short .6
        call ResetSampleReq
        call ResetSpeechQueue
        mov edx, 0Ah
.4:
        push str_Num
        push edx
        push str_DS
        lea eax, [byte esp+0Ch]
        push eax
        call sprintf_
        add esp, byte 10h
        mov eax, esp
        call RequestSample
        inc edx
        cmp edx, byte 14h
        jl short QueuePenaltyType.4
        mov edx, 0Ah
.5:
        push str_Num
        push edx
        push str_DS
        lea eax, [byte esp+0Ch]
        push eax
        call sprintf_
        add esp, byte 10h
        mov eax, esp
        call QueueSpeechClip
        inc edx
        cmp edx, byte 14h
        jl short QueuePenaltyType.5
.6:
        mov eax, dword [speechbank]
        mov edx, dword [dword eax+03B68h]
        sub edx, dword [dword eax+03B6Ch]
        cmp edx, 186A0h
        jbe short .9
        call ResetSampleReq
        call ResetSpeechQueue
        mov edx, 14h
.7:
        push str_Num
        push edx
        push str_DS
        lea eax, [byte esp+0Ch]
        push eax
        call sprintf_
        add esp, byte 10h
        mov eax, esp
        call RequestSample
        inc edx
        cmp edx, byte 1Eh
        jl short QueuePenaltyType.7
        mov edx, 14h
.8:
        push str_Num
        push edx
        push str_DS
        lea eax, [byte esp+0Ch]
        push eax
        call sprintf_
        add esp, byte 10h
        mov eax, esp
        call QueueSpeechClip
        inc edx
        cmp edx, byte 1Eh
        jl short QueuePenaltyType.8
.9:
        mov eax, dword [speechbank]
        mov edx, dword [dword eax+03B68h]
        sub edx, dword [dword eax+03B6Ch]
        cmp edx, 186A0h
        jbe short .12
        call ResetSampleReq
        call ResetSpeechQueue
        xor edx, edx
.10:
        push str_Num
        push edx
        push str_02dS
        lea eax, [byte esp+0Ch]
        push eax
        call sprintf_
        add esp, byte 10h
        mov eax, esp
        call RequestSample
        inc edx
        cmp edx, byte 0Ah
        jl short QueuePenaltyType.10
        xor edx, edx
.11:
        push str_Num
        push edx
        push str_02dS
        lea eax, [byte esp+0Ch]
        push eax
        call sprintf_
        add esp, byte 10h
        mov eax, esp
        call QueueSpeechClip
        inc edx
        cmp edx, byte 0Ah
        jl short QueuePenaltyType.11
.12:
        mov eax, dword [speechbank]
        mov edx, dword [dword eax+03B68h]
        sub edx, dword [dword eax+03B6Ch]
        cmp edx, 249F0h
        jbe short .x
        call ResetSampleReq
        call ResetSpeechQueue
        xor edx, edx
.13:
        mov eax, dword [nosplit edx*4+penaltyclips]
        call RequestSample
        inc edx
        cmp edx, byte 0Eh
        jl short QueuePenaltyType.13
        xor edx, edx
.14:
        mov eax, dword [nosplit edx*4+penaltyclips]
        call QueueSpeechClip
        inc edx
        cmp edx, byte 0Eh
        jl short QueuePenaltyType.14
.x:
        add esp, byte 10h
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; PreloadAnnouncerClips                        8579E  95 PC, medium confidence
; Opens XBRUCE2.VIV and requests the common goal / penalty clips
;-----------------------------------------------------------------------------
; C: src/front/announcer/PreloadAnnouncerClips.c
%ifdef CBUILD
%include "c/front/announcer/PreloadAnnouncerClips.inc"
%else
PreloadAnnouncerClips:
        push dword 54h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        sub esp, byte 30h
        mov esi, eax
        mov edi, edx
        cmp dword [speechinit], byte 0
        jne short .1
        xor eax, eax
        jmp near .x
.1:
        call SpeechIdle
        test eax, eax
        je near .x
        call ResetSampleReq
        call ResetSpeechQueue
        mov ecx, str_VIV
        mov ebx, str_XBRUCE2
        cmp byte [fileoncd+01C0h], 1
        jne short .2
        mov edx, dword [cddriveptr]
        jmp short .3
.2:
        xor edx, edx
.3:
        mov eax, esp
        call MakePath
        mov edx, 1Ah
        mov eax, esp
        call OpenSpeechBank
        push str_Tea
        push esi
        push str_SS5
        lea eax, [byte esp+02Ch]
        push eax
        call sprintf_
        add esp, byte 10h
        push str_Tea
        push edi
        push str_SS5
        lea eax, [byte esp+01Ch]
        push eax
        call sprintf_
        add esp, byte 10h
        mov eax, str_OneleftCor
        call RequestSample
        mov eax, str_PauseCor
        call RequestSample
        lea eax, [byte esp+020h]
        call RequestSample
        lea eax, [byte esp+010h]
        call RequestSample
        mov eax, str_GoalnumCor
        call RequestSample
        mov eax, str_AsstnumCor
        call RequestSample
        mov eax, str_AndnumCor
        call RequestSample
        mov eax, str_PennumCor
        call RequestSample
        mov eax, str_PensnumCor
        call RequestSample
        mov eax, str_2minCor
        call RequestSample
        mov eax, str_AtCor
        call RequestSample
        mov eax, str_OneleftCor
        call QueueSpeechClip
        mov eax, str_PauseCor
        call QueueSpeechClip
        lea eax, [byte esp+020h]
        call QueueSpeechClip
        lea eax, [byte esp+010h]
        call QueueSpeechClip
        mov eax, str_GoalnumCor
        call QueueSpeechClip
        mov eax, str_AsstnumCor
        call QueueSpeechClip
        mov eax, str_AndnumCor
        call QueueSpeechClip
        mov eax, str_PennumCor
        call QueueSpeechClip
        mov eax, str_PensnumCor
        call QueueSpeechClip
        mov eax, str_2minCor
        call QueueSpeechClip
        mov eax, str_AtCor
        call QueueSpeechClip
        call QueuePenaltyType
        mov eax, 1
.x:
        add esp, byte 30h
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
