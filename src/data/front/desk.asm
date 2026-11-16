; The desk menu items that pick which goalie is in net.
bits 32
%include "hockey.inc"
section s_CEE5F progbits alloc noexec write align=1
extern DeskGoToReplay, DeskHomeGoalie1, DeskHomeGoalie2, DeskHomeGoalieNone, DeskAwayGoalie1, DeskAwayGoalie2, DeskAwayGoalieNone, str_sp00XXXXXXXXXXXXXXXXX
extern str_sp00XXXXXXXXXXXXXXXXX2, str_spNONE, str_sp00XXXXXXXXXXXXXXXXX3, str_sp00XXXXXXXXXXXXXXXXX4, str_spNONE2, str_GoToReplay, str_HomeTeam2
global mi_HomeGoalie1, mi_HomeGoalie2, mi_HomeGoalieNone, mi_AwayGoalie1, mi_AwayGoalie2, mi_AwayGoalieNone, menuact_gotoreplay, awgoaliemenu
global DeskReplayMenu, DeskTeamLinesMenu
mi_HomeGoalie1:                                 ; goalie menu item (text pointer, action DeskHomeGoalie1);
                                                ; used by DeskHomeGoalie1, DeskHomeGoalie2, DeskHomeGoalieNone
                                                ; ...
        dd str_sp00XXXXXXXXXXXXXXXXX
        dd DeskHomeGoalie1
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h
        db 00h,00h,00h,00h,023h,00h,00h,00h
mi_HomeGoalie2:                                 ; goalie menu item (DeskHomeGoalie2); used by DeskHomeGoalie1,
                                                ; DeskHomeGoalie2, DeskHomeGoalieNone ...
        dd str_sp00XXXXXXXXXXXXXXXXX2
        dd DeskHomeGoalie2
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,024h,00h,00h,00h
        db 00h,00h,00h,00h,036h,00h,00h,00h
mi_HomeGoalieNone:                              ; goalie menu item (DeskHomeGoalieNone); used by
                                                ; DeskGoalie_x1, DeskHomeGoalieNone, ResetGoalieMenu
        dd str_spNONE
        dd DeskHomeGoalieNone
        db 00h,00h,00h,00h,00h,00h,00h,00h
awgoaliemenu:                                   ; SetupGoalieMenu: the away goalie submenu items
                                                ; (mi_AwayGoalie1...); used by SetSideControls,
                                                ; SetupGoalieMenu
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,011h,00h,00h,00h
mi_AwayGoalie1:                                 ; goalie menu item (DeskAwayGoalie1); used by DeskAwayGoalie1,
                                                ; DeskAwayGoalie2, DeskAwayGoalieNone ...
        dd str_sp00XXXXXXXXXXXXXXXXX3
        dd DeskAwayGoalie1
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h
        db 00h,00h,00h,00h,023h,00h,00h,00h
mi_AwayGoalie2:                                 ; goalie menu item (DeskAwayGoalie2); used by DeskAwayGoalie1,
                                                ; DeskAwayGoalie2, DeskAwayGoalieNone ...
        dd str_sp00XXXXXXXXXXXXXXXXX4
        dd DeskAwayGoalie2
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,024h,00h,00h,00h
        db 00h,00h,00h,00h,036h,00h,00h,00h
mi_AwayGoalieNone:                              ; goalie menu item (DeskAwayGoalieNone); used by
                                                ; DeskAwayGoalieNone, DeskGoalie_x3, ResetGoalieMenu
        dd str_spNONE2
        dd DeskAwayGoalieNone
        db 00h,00h,00h,00h,00h,00h,00h,00h
DeskReplayMenu:                                 ; Sports desk pull-down: Go To Replay
        db 00h,00h,00h,00h,00h,00h,00h,00h,06Bh,00h,00h,00h,011h,00h,00h,00h
        dd str_GoToReplay
menuact_gotoreplay:                             ; SportsDesk: action slot of 'Go To Replay' (0 when the replay
                                                ; is empty); used by SportsDesk
        dd DeskGoToReplay
        db 00h,00h,00h,00h,00h,00h,00h,00h
DeskTeamLinesMenu:                              ; Sports desk pull-down: home and visitor line editors
        db 00h,00h,00h,00h,00h,00h,00h,00h,06Eh,00h,00h,00h,011h,00h,00h,00h
        dd str_HomeTeam2
