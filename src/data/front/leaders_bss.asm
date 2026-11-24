; BSS of front/leaders (src/front/leaders).
bits 32
%include "hockey.inc"
section s_DD10C nobits alloc noexec write align=1
global statsteambuf, statsskaterbuf, statsgoaliebuf, statssortkeys, statsplayerbuf
statsteambuf:                                   ; team stat records (1Ah bytes); used by CalStandingsMenu,
                                                ; CalStandingsMenu_player2, CalStandingsScreen ...
        resb 4
statsskaterbuf:                                 ; skater stat records (2Fh bytes, playoffs +12h); used by
                                                ; CalStandingsMenu, CalStandingsMenu_player2, CmpAssists ...
        resb 4
statsgoaliebuf:                                 ; goalie stat records (36h bytes, playoffs +16h); used by
                                                ; CalStandingsMenu, CalStandingsMenu_player2, CmpGAA ...
        resb 4
statssortkeys:                                  ; "addsort" buffer, per-entry sort keys; used by CmpShootPct,
                                                ; CmpTeamPK, CmpTeamPP ...
        resb 4
statsplayerbuf:                                 ; player records (34h bytes; +2 pos, +3 first, +13h last
                                                ; name); used by CalStandingsMenu, CalStandingsMenu_player2,
                                                ; EasnStandingsMenu_m ...
        resb 4
