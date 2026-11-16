; Allocation tags for the player and goalie stat blocks, and the names of the periods.
bits 32
%include "hockey.inc"
section s_C1AA4 progbits alloc noexec write align=1
global tag_pset, tag_aps, tag_apset, tag_gset, tag_ags, tag_agset, str_LoadPic, str_Pal23
global tag_t, tag_at, tag_pk, tag_ps, tag_gk, tag_gs, str_Fanom, str_Goal
global str_Clap2, str_Uflag, str_Cflag, str_Siren2, str_Ruff, str_Hook3, str_Saved2, str_Cross
global str_Guilt, str_1st, str_2nd, str_3rd
tag_t:                                          ; allocation tag "t" (team record, 2E8h); used by SimulateGame
        db 074h,00h
tag_at:                                         ; allocation tag "at"; used by SimulateGame
        db 061h,074h,00h
tag_pk:                                         ; allocation tag "pk"; used by SimulateGame
        db 070h,06Bh,00h
tag_ps:                                         ; allocation tag "ps"; used by SimulateGame
        db 070h,073h,00h
tag_pset:                                       ; allocation tag "pset"; used by SimulateGame
        db 070h,073h,065h,074h,00h
tag_aps:                                        ; allocation tag "aps"; used by SimulateGame
        db 061h,070h,073h,00h
tag_apset:                                      ; allocation tag "apset"; used by SimulateGame
        db 061h,070h,073h,065h,074h,00h
tag_gk:                                         ; allocation tag "gk"; used by SimulateGame
        db 067h,06Bh,00h
tag_gs:                                         ; allocation tag "gs"; used by SimulateGame
        db 067h,073h,00h
tag_gset:                                       ; allocation tag "gset"; used by SimulateGame
        db 067h,073h,065h,074h,00h
tag_ags:                                        ; allocation tag "ags"; used by SimulateGame
        db 061h,067h,073h,00h
tag_agset:                                      ; allocation tag "agset"; used by SimulateGame
        db 061h,067h,073h,065h,074h,00h,00h
str_LoadPic:                                    ; "load"; used by ShowLoadingScreen
        db 06Ch,06Fh,061h,064h,00h
str_Pal23:                                      ; "!pal"; used by ShowLoadingScreen
        db 021h,070h,061h,06Ch,00h,00h,00h
str_Fanom:                                      ; "fanom" string literal
        db 066h,061h,06Eh,06Fh,06Dh,00h
str_Goal:                                       ; "goal" string literal
        db 067h,06Fh,061h,06Ch,00h
str_Clap2:                                      ; "clap" string literal
        db 063h,06Ch,061h,070h,00h
str_Uflag:                                      ; "uflag" string literal
        db 075h,066h,06Ch,061h,067h,00h
str_Cflag:                                      ; "cflag" string literal
        db 063h,066h,06Ch,061h,067h,00h
str_Siren2:                                     ; "siren" string literal
        db 073h,069h,072h,065h,06Eh,00h
str_Ruff:                                       ; "ruff" string literal
        db 072h,075h,066h,066h,00h
str_Hook3:                                      ; "hook" string literal
        db 068h,06Fh,06Fh,06Bh,00h
str_Saved2:                                     ; "saved" string literal
        db 073h,061h,076h,065h,064h,00h
str_Cross:                                      ; "cross" string literal
        db 063h,072h,06Fh,073h,073h,00h
str_Guilt:                                      ; "guilt" string literal
        db 067h,075h,069h,06Ch,074h,00h,00h,00h
str_1st:                                        ; "1st" (starordtab)
        db 031h,073h,074h,00h
str_2nd:                                        ; "2nd" (starordtab)
        db 032h,06Eh,064h,00h
str_3rd:                                        ; "3rd" (starordtab)
        db 033h,072h,064h,00h
