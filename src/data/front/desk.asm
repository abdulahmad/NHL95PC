; The desk menu items that pick which goalie is in net.
bits 32
%include "hockey.inc"
section s_CEE5F progbits alloc noexec write align=1
extern DeskGoToReplay, DeskHomeGoalie1, DeskHomeGoalie2, DeskHomeGoalieNone, DeskAwayGoalie1, DeskAwayGoalie2, DeskAwayGoalieNone, str_sp00XXXXXXXXXXXXXXXXX
extern str_sp00XXXXXXXXXXXXXXXXX2, str_spNONE, str_sp00XXXXXXXXXXXXXXXXX3, str_sp00XXXXXXXXXXXXXXXXX4, str_spNONE2, str_GoToReplay, str_HomeTeam2
global mi_HomeGoalie1, mi_HomeGoalie2, mi_HomeGoalieNone, mi_AwayGoalie1, mi_AwayGoalie2, mi_AwayGoalieNone, menuact_gotoreplay, awgoaliemenu
global unk_CEF0F, unk_CEF2F
mi_HomeGoalie1:
        dd str_sp00XXXXXXXXXXXXXXXXX
        dd DeskHomeGoalie1
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h
        db 00h,00h,00h,00h,023h,00h,00h,00h
mi_HomeGoalie2:
        dd str_sp00XXXXXXXXXXXXXXXXX2
        dd DeskHomeGoalie2
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,024h,00h,00h,00h
        db 00h,00h,00h,00h,036h,00h,00h,00h
mi_HomeGoalieNone:
        dd str_spNONE
        dd DeskHomeGoalieNone
        db 00h,00h,00h,00h,00h,00h,00h,00h
awgoaliemenu:
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,011h,00h,00h,00h
mi_AwayGoalie1:
        dd str_sp00XXXXXXXXXXXXXXXXX3
        dd DeskAwayGoalie1
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h
        db 00h,00h,00h,00h,023h,00h,00h,00h
mi_AwayGoalie2:
        dd str_sp00XXXXXXXXXXXXXXXXX4
        dd DeskAwayGoalie2
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,024h,00h,00h,00h
        db 00h,00h,00h,00h,036h,00h,00h,00h
mi_AwayGoalieNone:
        dd str_spNONE2
        dd DeskAwayGoalieNone
        db 00h,00h,00h,00h,00h,00h,00h,00h
unk_CEF0F:
        db 00h,00h,00h,00h,00h,00h,00h,00h,06Bh,00h,00h,00h,011h,00h,00h,00h
        dd str_GoToReplay
menuact_gotoreplay:
        dd DeskGoToReplay
        db 00h,00h,00h,00h,00h,00h,00h,00h
unk_CEF2F:
        db 00h,00h,00h,00h,00h,00h,00h,00h,06Eh,00h,00h,00h,011h,00h,00h,00h
        dd str_HomeTeam2
