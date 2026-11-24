; Strings and constants of front/announcer (src/front/announcer), in link order.
bits 32
%include "hockey.inc"
section s_C37D8 progbits alloc noexec write align=1
global str_Cor, str_GamemiscS, str_EastquadBar, str_EastsemdBar, str_EastfindBar, str_WestquadBar, str_WestsemdBar, str_WestfindBar
global str_StanleydBar, str_EastquauBar, str_EastsemuBar, str_EastfinuBar, str_WestquauBar, str_WestsemuBar, str_WestfinuBar, str_StanleyuBar
global str_NhlInt, str_ElsenhlInt, str_Rnk, str_Awa, str_Hom, str_Bar, str_Gamenum, str_SSS
global str_Num, str_DS, str_02dS, str_Tea, str_Pen, str_Frm, str_XBRUCE2
str_Cor:                                        ; string 'cor'; used by PenaltyLenClip
        db 063h,06Fh,072h,00h
str_GamemiscS:                                  ; string 'gamemisc.%s'; used by PenaltyLenClip
        db 067h,061h,06Dh,065h,06Dh,069h,073h,063h,02Eh,025h,073h,00h
str_EastquadBar:                                ; string 'eastquad.bar'; used by PlayoffRoundClipD
        db 065h,061h,073h,074h,071h,075h,061h,064h,02Eh,062h,061h,072h,00h
str_EastsemdBar:                                ; string 'eastsemd.bar'; used by PlayoffRoundClipD
        db 065h,061h,073h,074h,073h,065h,06Dh,064h,02Eh,062h,061h,072h,00h
str_EastfindBar:                                ; string 'eastfind.bar'; used by PlayoffRoundClipD
        db 065h,061h,073h,074h,066h,069h,06Eh,064h,02Eh,062h,061h,072h,00h
str_WestquadBar:                                ; string 'westquad.bar'; used by PlayoffRoundClipD
        db 077h,065h,073h,074h,071h,075h,061h,064h,02Eh,062h,061h,072h,00h
str_WestsemdBar:                                ; string 'westsemd.bar'; used by PlayoffRoundClipD
        db 077h,065h,073h,074h,073h,065h,06Dh,064h,02Eh,062h,061h,072h,00h
str_WestfindBar:                                ; string 'westfind.bar'; used by PlayoffRoundClipD
        db 077h,065h,073h,074h,066h,069h,06Eh,064h,02Eh,062h,061h,072h,00h
str_StanleydBar:                                ; string 'stanleyd.bar'; used by PlayoffRoundClipD
        db 073h,074h,061h,06Eh,06Ch,065h,079h,064h,02Eh,062h,061h,072h,00h
str_EastquauBar:                                ; string 'eastquau.bar'; used by PlayoffRoundClipU
        db 065h,061h,073h,074h,071h,075h,061h,075h,02Eh,062h,061h,072h,00h
str_EastsemuBar:                                ; string 'eastsemu.bar'; used by PlayoffRoundClipU
        db 065h,061h,073h,074h,073h,065h,06Dh,075h,02Eh,062h,061h,072h,00h
str_EastfinuBar:                                ; string 'eastfinu.bar'; used by PlayoffRoundClipU
        db 065h,061h,073h,074h,066h,069h,06Eh,075h,02Eh,062h,061h,072h,00h
str_WestquauBar:                                ; string 'westquau.bar'; used by PlayoffRoundClipU
        db 077h,065h,073h,074h,071h,075h,061h,075h,02Eh,062h,061h,072h,00h
str_WestsemuBar:                                ; string 'westsemu.bar'; used by PlayoffRoundClipU
        db 077h,065h,073h,074h,073h,065h,06Dh,075h,02Eh,062h,061h,072h,00h
str_WestfinuBar:                                ; string 'westfinu.bar'; used by PlayoffRoundClipU
        db 077h,065h,073h,074h,066h,069h,06Eh,075h,02Eh,062h,061h,072h,00h
str_StanleyuBar:                                ; string 'stanleyu.bar'; used by PlayoffRoundClipU
        db 073h,074h,061h,06Eh,06Ch,065h,079h,075h,02Eh,062h,061h,072h,00h
str_NhlInt:                                     ; string 'nhl.int'; used by SayNhlIntro
        db 06Eh,068h,06Ch,02Eh,069h,06Eh,074h,00h
str_ElsenhlInt:                                 ; string 'elsenhl.int'; used by SayElseNhl
        db 065h,06Ch,073h,065h,06Eh,068h,06Ch,02Eh,069h,06Eh,074h,00h
str_Rnk:                                        ; string 'rnk'; used by SayHighlightIntro, SayPlayoffTonight,
                                                ; SayTonightIntro
        db 072h,06Eh,06Bh,00h
str_Awa:                                        ; string 'awa'; used by SayHighlightIntro, SayPlayoffResult,
                                                ; SayPlayoffTonight ...
        db 061h,077h,061h,00h
str_Hom:                                        ; string 'hom'; used by SayHighlightIntro, SayPlayoffTonight,
                                                ; SayTonightIntro
        db 068h,06Fh,06Dh,00h
str_Bar:                                        ; string 'bar'; used by SayPlayoffResult, SayPlayoffTonight
        db 062h,061h,072h,00h
str_Gamenum:                                    ; string 'gamenum'; used by SayPlayoffResult,
                                                ; SayPlayoffTonight
        db 067h,061h,06Dh,065h,06Eh,075h,06Dh,00h
str_SSS:                                        ; string '%s%s.%s'; used by SayPlayoffResult,
                                                ; SayPlayoffTonight
        db 025h,073h,025h,073h,02Eh,025h,073h,00h
str_Num:                                        ; string 'num'; used by QueuePenaltyType, QueueTimeClips,
                                                ; RequestTimeClips ...
        db 06Eh,075h,06Dh,00h
str_DS:                                         ; string '%d.%s'; used by QueuePenaltyType, QueueTimeClips,
                                                ; RequestTimeClips ...
        db 025h,064h,02Eh,025h,073h,00h
str_02dS:                                       ; string '%02d.%s'; used by QueuePenaltyType, QueueTimeClips,
                                                ; RequestTimeClips
        db 025h,030h,032h,064h,02Eh,025h,073h,00h
str_Tea:                                        ; string 'tea'; used by PreloadAnnouncerClips, SayGoal,
                                                ; SayPenalty ...
        db 074h,065h,061h,00h
str_Pen:                                        ; string 'pen'; used by SayPenalty
        db 070h,065h,06Eh,00h
str_Frm:                                        ; string 'frm'; used by SayPlayerNumber
        db 066h,072h,06Dh,00h
str_XBRUCE2:                                    ; string 'XBRUCE2'; used by OpenAnnouncerBank,
                                                ; PreloadAnnouncerClips
        db 058h,042h,052h,055h,043h,045h,032h,00h
