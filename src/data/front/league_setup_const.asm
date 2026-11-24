; Strings and constants of front/league_setup (src/front/league_setup), in link order.
bits 32
%include "hockey.inc"
section s_C188D progbits alloc noexec write align=1
global str_PLST, str_PTLS, str_Pal19, str_TPI, str_Embnhl, str_Bkgd8, str_Pointer9, str_Iff10
global str_Leaguetm2, str_Tspal, str_Pal20, str_Menubuff6, str_WhoWillPlayThe, str_MightyDucksOfAnaheim3, str_qmark
str_PLST:                                       ; string 'PLST'; used by ChooseLeagueController
        db 050h,04Ch,053h,054h,00h
str_PTLS:                                       ; string 'PTLS'; used by ChooseLeagueController
        db 050h,054h,04Ch,053h,00h
str_Pal19:                                      ; string 'Pal'; used by LeagueTeamSelect
        db 050h,061h,06Ch,00h
str_TPI:                                        ; string 'TPI'; used by LeagueTeamSelect
        db 054h,050h,049h,00h
str_Embnhl:                                     ; string 'embnhl'; used by LeagueTeamSelect
        db 065h,06Dh,062h,06Eh,068h,06Ch,00h
str_Bkgd8:                                      ; string 'bkgd'; used by LeagueTeamSelect
        db 062h,06Bh,067h,064h,00h
str_Pointer9:                                   ; string 'Pointer'; used by LeagueTeamSelect
        db 050h,06Fh,069h,06Eh,074h,065h,072h,00h
str_Iff10:                                      ; string '.iff'; used by LeagueTeamSelect
        db 02Eh,069h,066h,066h,00h
str_Leaguetm2:                                  ; string 'leaguetm'; used by LeagueTeamSelect
        db 06Ch,065h,061h,067h,075h,065h,074h,06Dh,00h
str_Tspal:                                      ; string 'tspal'; used by LeagueTeamSelect
        db 074h,073h,070h,061h,06Ch,00h
str_Pal20:                                      ; string '!pal'; used by LeagueTeamSelect
        db 021h,070h,061h,06Ch,00h
str_Menubuff6:                                  ; string 'menubuff'; used by LeagueTeamSelect
        db 06Dh,065h,06Eh,075h,062h,075h,066h,066h,00h
str_WhoWillPlayThe:                             ; string 'Who will play the '; used by LeagueTeamSelect
        db 057h,068h,06Fh,020h,077h,069h,06Ch,06Ch,020h,070h,06Ch,061h,079h,020h,074h,068h
        db 065h,020h,00h
str_MightyDucksOfAnaheim3:                      ; string 'Mighty Ducks of Anaheim'; used by LeagueTeamSelect
        db 04Dh,069h,067h,068h,074h,079h,020h,044h,075h,063h,06Bh,073h,020h,06Fh,066h,020h
        db 041h,06Eh,061h,068h,065h,069h,06Dh,00h
str_qmark:                                      ; string '?'; used by LeagueTeamSelect
        db 03Fh,00h,00h,00h
