; Announcer: which clip to say and when (PC only).
bits 32
%include "hockey.inc"
section s_842BA progbits alloc exec nowrite align=1
extern __CHK, cddriveptr, EnsureSampleRoom, fileoncd, FindFreeSpeechSlot, FindSpeechSlot, itoa_, LoadSpeechSlot
extern MakePath, oneminsaid, OpenSpeechBank, penaltyclips, PlaceSpeechSlot, RequestSample, ResetSampleReq, ResetSpeechQueue
extern scorperclips, ShutdownSpeech, ShutdownSpeech_ret6, speechbank, SpeechIdle, speechinit, speechq, SpeechSlotLoaded
extern sprintf_, str_02dS, str_1minuteCor, str_1secondCor, str_2minCor, str_5minCor, str_AndBar, str_AndnumCor
extern str_AsstnumCor, str_AtCor, str_Awa, str_BackmomtInt, str_Bar, str_BetweenBar, str_CoachclpInt, str_Cor
extern str_Cor2, str_DS, str_EasportsBar, str_EastfindBar, str_EastfinuBar, str_EastquadBar, str_EastquauBar, str_EastsemdBar
extern str_EastsemuBar, str_ElsenhlInt, str_Frm, str_GamebtwnBar, str_GamemiscS, str_Gamenum, str_GamenumBar, str_GoalnumCor
extern str_GoodniteInt, str_HavewonBar, str_HighliteBar, str_Hom, str_LineupsInt, str_MinutesCor, str_NhlInt, str_NowbackInt
extern str_Num, str_NumberCor, str_OfBar, str_OneleftCor, str_OvertimeBar, str_PauseCor, str_Pen, str_PennumCor
extern str_PenshotCor, str_PensnumCor, str_Rnk, str_Scor1otpBar, str_Scor1perBar, str_Scor2otpBar, str_Scor2perBar, str_Scor3otpBar
extern str_Scor3perBar, str_ScortotpBar, str_SecondsCor, str_SS5, str_SSS, str_StanleydBar, str_StanleyuBar, str_TakeynowBar
extern str_Tea, str_ThegameBar, str_TonightBar, str_VIV, str_WestfindBar, str_WestfinuBar, str_WestquadBar, str_WestquauBar
extern str_WestsemdBar, str_WestsemuBar, str_XBRUCE2, strcpy_, strncpy_
global PenaltyLenClip, PlayoffRoundClipD, PlayoffRoundClipU, QueueSpeechClip, LoadClipSlot, SayClip_body, SayScorePeriod, SayNhlIntro
global SayGoodnight, SayLineups, SayNowBack, FreeNowBack, SayBackMoment, FreeBackMoment, SayCoachClip, FreeCoachClip
global FreeClip, FreeClip_ret, SayElseNhl, SayHighlightIntro, SayPlayoffResult, SayTheGame, SayScoringPeriod, SayClip
global SayScoringPeriod_ot2, SayScoringPeriod_ot3, SayScoringPeriod_ott, SayScoringPeriod_reg, SayTonightIntro, SayPlayoffTonight, RequestTimeClips, QueueTimeClips
global SayPenalty, SayPenaltyShot, SayPlayerNumber, SayGoal, SayOneMinuteLeft, OpenAnnouncerBank, QueuePenaltyType, PreloadAnnouncerClips
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
; C: src/front/speech/ShutdownSpeech.c (QueueSpeechClip)
%ifdef CBUILD
%include "c/front/speech/ShutdownSpeech.QueueSpeechClip.inc"
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
; C: src/front/speech/ShutdownSpeech.c (LoadClipSlot)
%ifdef CBUILD
%include "c/front/speech/ShutdownSpeech.LoadClipSlot.inc"
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
; C: src/front/speech/ShutdownSpeech.c (SayClip_body)
%ifdef CBUILD
%include "c/front/speech/ShutdownSpeech.SayClip_body.inc"
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
; C: src/front/speech/ShutdownSpeech.c (SayScorePeriod)
%ifdef CBUILD
%include "c/front/speech/ShutdownSpeech.SayScorePeriod.inc"
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
; C: src/front/speech/ShutdownSpeech.c (SayNhlIntro)
%ifdef CBUILD
%include "c/front/speech/ShutdownSpeech.SayNhlIntro.inc"
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
; C: src/front/speech/ShutdownSpeech.c (SayHighlightIntro)
%ifdef CBUILD
%include "c/front/speech/ShutdownSpeech.SayHighlightIntro.inc"
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
; C: src/front/speech/ShutdownSpeech.c (SayPlayoffResult)
%ifdef CBUILD
%include "c/front/speech/ShutdownSpeech.SayPlayoffResult.inc"
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
; C: src/front/speech/ShutdownSpeech.c (SayTheGame)
%ifdef CBUILD
%include "c/front/speech/ShutdownSpeech.SayTheGame.inc"
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
; C: src/front/speech/ShutdownSpeech.c (SayScoringPeriod)
%ifdef CBUILD
%include "c/front/speech/ShutdownSpeech.SayScoringPeriod.inc"
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
; C: src/front/speech/ShutdownSpeech.c (SayClip)
%ifdef CBUILD
%include "c/front/speech/ShutdownSpeech.SayClip.inc"
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
; C: src/front/speech/ShutdownSpeech.c (SayScoringPeriod_ot2)
%ifdef CBUILD
%include "c/front/speech/ShutdownSpeech.SayScoringPeriod_ot2.inc"
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
