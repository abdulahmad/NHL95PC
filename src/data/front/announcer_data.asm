; Initialised data of front/announcer (src/front/announcer).
bits 32
%include "hockey.inc"
section s_D24DC progbits alloc noexec write align=1
extern str_AbusePen, str_BoardingPen, str_ChargingPen, str_CheckbndPen, str_ElbowingPen, str_HistickPen, str_HoldingPen, str_HookingPen
extern str_InterferPen, str_RoughingPen, str_SlashingPen, str_SpearingPen, str_TrippingPen, str_XcheckPen
global str_SS5, str_PauseCor, str_AtCor, str_1minuteCor, str_MinutesCor, str_1secondCor, str_SecondsCor, str_PennumCor
global str_PensnumCor, str_PenshotCor, str_GoalnumCor, str_AsstnumCor, str_AndnumCor, str_OneleftCor, str_2minCor, str_5minCor
global str_NumberCor, str_NowbackInt, str_BackmomtInt, str_CoachclpInt, str_OfBar, str_AndBar, str_BetweenBar, str_GamenumBar
global str_EasportsBar, str_TonightBar, str_GamebtwnBar, str_GoodniteInt, str_LineupsInt, str_TakeynowBar, str_HighliteBar, str_OvertimeBar
global str_HavewonBar, str_Scor1perBar, str_Scor2perBar, str_Scor3perBar, str_Scor1otpBar, str_Scor2otpBar, str_Scor3otpBar, str_ScortotpBar
global str_ThegameBar, penaltyclips, scorperclips, str_1ststarCor, str_2ndstarCor, str_3rdstar, str_Cor2, speechchannel
global SpeechInitMode, speechcopylen, speechinit, str_VIV, str_SavingCurrent, str_LeagueGame, str_PlayOffGame
str_SS5:                                        ; string '%s.%s'; used by PreloadAnnouncerClips, SayGoal,
                                                ; SayHighlightIntro ...
        db 025h,073h,02Eh,025h,073h,00h
str_PauseCor:                                   ; string 'pause.cor'; used by PreloadAnnouncerClips,
                                                ; QueueTimeClips, RequestTimeClips ...
        db 070h,061h,075h,073h,065h,02Eh,063h,06Fh,072h,00h
str_AtCor:                                      ; string 'at.cor'; used by PreloadAnnouncerClips,
                                                ; QueueTimeClips, RequestTimeClips
        db 061h,074h,02Eh,063h,06Fh,072h,00h
str_1minuteCor:                                 ; string '1minute.cor'; used by QueueTimeClips,
                                                ; RequestTimeClips
        db 031h,06Dh,069h,06Eh,075h,074h,065h,02Eh,063h,06Fh,072h,00h
str_MinutesCor:                                 ; string 'minutes.cor'; used by QueueTimeClips,
                                                ; RequestTimeClips
        db 06Dh,069h,06Eh,075h,074h,065h,073h,02Eh,063h,06Fh,072h,00h
str_1secondCor:                                 ; string '1second.cor'; used by QueueTimeClips,
                                                ; RequestTimeClips
        db 031h,073h,065h,063h,06Fh,06Eh,064h,02Eh,063h,06Fh,072h,00h
str_SecondsCor:                                 ; string 'seconds.cor'; used by QueueTimeClips,
                                                ; RequestTimeClips
        db 073h,065h,063h,06Fh,06Eh,064h,073h,02Eh,063h,06Fh,072h,00h
str_PennumCor:                                  ; string 'pennum.cor'; used by PreloadAnnouncerClips,
                                                ; SayPenalty
        db 070h,065h,06Eh,06Eh,075h,06Dh,02Eh,063h,06Fh,072h,00h
str_PensnumCor:                                 ; string 'pensnum.cor'; used by PreloadAnnouncerClips,
                                                ; SayPenalty
        db 070h,065h,06Eh,073h,06Eh,075h,06Dh,02Eh,063h,06Fh,072h,00h
str_PenshotCor:                                 ; string 'penshot.cor'; used by SayPenaltyShot
        db 070h,065h,06Eh,073h,068h,06Fh,074h,02Eh,063h,06Fh,072h,00h
str_GoalnumCor:                                 ; string 'goalnum.cor'; used by PreloadAnnouncerClips, SayGoal
        db 067h,06Fh,061h,06Ch,06Eh,075h,06Dh,02Eh,063h,06Fh,072h,00h
str_AsstnumCor:                                 ; string 'asstnum.cor'; used by PreloadAnnouncerClips, SayGoal
        db 061h,073h,073h,074h,06Eh,075h,06Dh,02Eh,063h,06Fh,072h,00h
str_AndnumCor:                                  ; string 'andnum.cor'; used by PreloadAnnouncerClips, SayGoal,
                                                ; SayPenalty
        db 061h,06Eh,064h,06Eh,075h,06Dh,02Eh,063h,06Fh,072h,00h
str_OneleftCor:                                 ; string 'oneleft.cor'; used by PreloadAnnouncerClips,
                                                ; SayGoal, SayOneMinuteLeft ...
        db 06Fh,06Eh,065h,06Ch,065h,066h,074h,02Eh,063h,06Fh,072h,00h
str_2minCor:                                    ; string '2min.cor'; used by PenaltyLenClip,
                                                ; PreloadAnnouncerClips
        db 032h,06Dh,069h,06Eh,02Eh,063h,06Fh,072h,00h
str_5minCor:                                    ; string '5min.cor'; used by PenaltyLenClip
        db 035h,06Dh,069h,06Eh,02Eh,063h,06Fh,072h,00h
str_NumberCor:                                  ; string 'number.cor'; used by SayPlayerNumber
        db 06Eh,075h,06Dh,062h,065h,072h,02Eh,063h,06Fh,072h,00h,065h,061h,073h,070h,06Fh
        db 072h,074h,073h,02Eh,069h,06Eh,074h,00h
str_NowbackInt:                                 ; string 'nowback.int'; used by FreeNowBack, SayNowBack
        db 06Eh,06Fh,077h,062h,061h,063h,06Bh,02Eh,069h,06Eh,074h,00h
str_BackmomtInt:                                ; string 'backmomt.int'; used by FreeBackMoment, SayBackMoment
        db 062h,061h,063h,06Bh,06Dh,06Fh,06Dh,074h,02Eh,069h,06Eh,074h,00h
str_CoachclpInt:                                ; string 'coachclp.int'; used by FreeCoachClip, SayCoachClip
        db 063h,06Fh,061h,063h,068h,063h,06Ch,070h,02Eh,069h,06Eh,074h,00h,06Eh,068h,06Ch
        db 02Eh,069h,06Eh,074h,00h
str_OfBar:                                      ; string 'of.bar'; used by SayHighlightIntro,
                                                ; SayPlayoffResult, SayPlayoffTonight
        db 06Fh,066h,02Eh,062h,061h,072h,00h,06Eh,075h,06Dh,062h,065h,072h,02Eh,062h,061h
        db 072h,00h,064h,069h,076h,069h,073h,069h,06Fh,06Eh,02Eh,062h,061h,072h,00h,063h
        db 06Fh,06Eh,066h,02Eh,062h,061h,072h,00h,066h,069h,06Eh,061h,06Ch,02Eh,062h,061h
        db 072h,00h,073h,065h,06Dh,069h,02Eh,062h,061h,072h,00h
str_AndBar:                                     ; string 'and.bar'; used by SayHighlightIntro,
                                                ; SayPlayoffTonight, SayTonightIntro
        db 061h,06Eh,064h,02Eh,062h,061h,072h,00h
str_BetweenBar:                                 ; string 'between.bar'; used by SayPlayoffTonight
        db 062h,065h,074h,077h,065h,065h,06Eh,02Eh,062h,061h,072h,00h
str_GamenumBar:                                 ; string 'gamenum.bar'; used by SayPlayoffResult
        db 067h,061h,06Dh,065h,06Eh,075h,06Dh,02Eh,062h,061h,072h,00h
str_EasportsBar:                                ; string 'easports.bar'; used by SayPlayoffTonight,
                                                ; SayTonightIntro
        db 065h,061h,073h,070h,06Fh,072h,074h,073h,02Eh,062h,061h,072h,00h
str_TonightBar:                                 ; string 'tonight.bar'; used by SayPlayoffTonight,
                                                ; SayTonightIntro
        db 074h,06Fh,06Eh,069h,067h,068h,074h,02Eh,062h,061h,072h,00h
str_GamebtwnBar:                                ; string 'gamebtwn.bar'; used by SayHighlightIntro,
                                                ; SayTonightIntro
        db 067h,061h,06Dh,065h,062h,074h,077h,06Eh,02Eh,062h,061h,072h,00h,070h,072h,065h
        db 073h,065h,06Eh,074h,073h,02Eh,069h,06Eh,074h,00h,068h,06Fh,063h,06Bh,065h,079h
        db 02Eh,069h,06Eh,074h,00h,069h,06Dh,072h,062h,061h,072h,072h,02Eh,069h,06Eh,074h
        db 00h
str_GoodniteInt:                                ; string 'goodnite.int'; used by SayGoodnight
        db 067h,06Fh,06Fh,064h,06Eh,069h,074h,065h,02Eh,069h,06Eh,074h,00h
str_LineupsInt:                                 ; string 'lineups.int'; used by SayLineups
        db 06Ch,069h,06Eh,065h,075h,070h,073h,02Eh,069h,06Eh,074h,00h,065h,06Ch,073h,065h
        db 077h,068h,065h,072h,02Eh,069h,06Eh,074h,00h,074h,06Fh,06Eh,069h,067h,068h,074h
        db 02Eh,069h,06Eh,074h,00h
str_TakeynowBar:                                ; string 'takeynow.bar'; used by SayHighlightIntro
        db 074h,061h,06Bh,065h,079h,06Eh,06Fh,077h,02Eh,062h,061h,072h,00h
str_HighliteBar:                                ; string 'highlite.bar'; used by SayHighlightIntro
        db 068h,069h,067h,068h,06Ch,069h,074h,065h,02Eh,062h,061h,072h,00h
str_OvertimeBar:                                ; string 'overtime.bar'; used by SayPlayoffResult
        db 06Fh,076h,065h,072h,074h,069h,06Dh,065h,02Eh,062h,061h,072h,00h
str_HavewonBar:                                 ; string 'havewon.bar'; used by SayPlayoffResult
        db 068h,061h,076h,065h,077h,06Fh,06Eh,02Eh,062h,061h,072h,00h
str_Scor1perBar:                                ; string 'scor1per.bar'; used by SayScoringPeriod_reg
        db 073h,063h,06Fh,072h,031h,070h,065h,072h,02Eh,062h,061h,072h,00h
str_Scor2perBar:                                ; string 'scor2per.bar'; used by SayScoringPeriod_reg
        db 073h,063h,06Fh,072h,032h,070h,065h,072h,02Eh,062h,061h,072h,00h
str_Scor3perBar:                                ; string 'scor3per.bar'; used by SayScoringPeriod_reg
        db 073h,063h,06Fh,072h,033h,070h,065h,072h,02Eh,062h,061h,072h,00h
str_Scor1otpBar:                                ; string 'scor1otp.bar'; used by SayScoringPeriod
        db 073h,063h,06Fh,072h,031h,06Fh,074h,070h,02Eh,062h,061h,072h,00h
str_Scor2otpBar:                                ; string 'scor2otp.bar'; used by SayScoringPeriod_ot2
        db 073h,063h,06Fh,072h,032h,06Fh,074h,070h,02Eh,062h,061h,072h,00h
str_Scor3otpBar:                                ; string 'scor3otp.bar'; used by SayScoringPeriod_ot3
        db 073h,063h,06Fh,072h,033h,06Fh,074h,070h,02Eh,062h,061h,072h,00h
str_ScortotpBar:                                ; string 'scortotp.bar'; used by SayScoringPeriod_ott
        db 073h,063h,06Fh,072h,074h,06Fh,074h,070h,02Eh,062h,061h,072h,00h
str_ThegameBar:                                 ; string 'thegame.bar'; used by SayScoringPeriod, SayTheGame
        db 074h,068h,065h,067h,061h,06Dh,065h,02Eh,062h,061h,072h,00h
penaltyclips:                                   ; 'roughing.pen' ... penalty clip names; used by
                                                ; QueuePenaltyType
        dd str_RoughingPen
        dd str_ChargingPen
        dd str_SlashingPen
        dd str_XcheckPen
        dd str_HookingPen
        dd str_TrippingPen
        dd str_InterferPen
        dd str_HoldingPen
        dd str_AbusePen
        dd str_CheckbndPen
        dd str_BoardingPen
        dd str_ElbowingPen
        dd str_HistickPen
        dd str_SpearingPen
scorperclips:                                   ; 'scor1per.bar' ... clip names; used by SayScorePeriod
        dd str_Scor1perBar
        dd str_Scor2perBar
        dd str_Scor3perBar
str_1ststarCor:                                 ; "1ststar.cor" string literal
        db 031h,073h,074h,073h,074h,061h,072h,02Eh,063h,06Fh,072h,00h
str_2ndstarCor:                                 ; "2ndstar.cor" string literal
        db 032h,06Eh,064h,073h,074h,061h,072h,02Eh,063h,06Fh,072h,00h
str_3rdstar:                                    ; Speech file name stem for the third star call
        db 033h,072h,064h,073h,074h,061h,072h,02Eh
str_Cor2:                                       ; "cor" string literal; used by SayPlayerNumber
        db 063h,06Fh,072h,00h
        dd str_1ststarCor
        dd str_2ndstarCor
        dd str_3rdstar
speechchannel:                                  ; SpeechTimerTick: sound channel of the next speech clip,
                                                ; toggled 0 / 1 per clip; used by InitSpeech, SpeechTimerTick
        db 00h,00h,00h,00h
SpeechInitMode:                                 ; Argument InitSpeech keeps; used by InitSpeech
        db 00h
speechcopylen:                                  ; copy buffer size; used by InitSpeech, MoveSampleMem
        db 00h,00h,00h,00h
speechinit:                                     ; 1 after InitSpeech, 0 after shutdown; used by InitSpeech,
                                                ; MusicChanReset, OpenAnnouncerBank ...
        db 00h,00h,00h,00h
str_VIV:                                        ; string '.VIV'; used by OpenAnnouncerBank,
                                                ; PreloadAnnouncerClips
        db 02Eh,056h,049h,056h,00h
str_SavingCurrent:                              ; "Saving Current" string literal
        db 053h,061h,076h,069h,06Eh,067h,020h,043h,075h,072h,072h,065h,06Eh,074h,00h
str_LeagueGame:                                 ; "League Game." string literal
        db 04Ch,065h,061h,067h,075h,065h,020h,047h,061h,06Dh,065h,02Eh,00h
str_PlayOffGame:                                ; "Play-Off Game." string literal
        db 050h,06Ch,061h,079h,02Dh,04Fh,066h,066h,020h,047h,061h,06Dh,065h,02Eh,00h
