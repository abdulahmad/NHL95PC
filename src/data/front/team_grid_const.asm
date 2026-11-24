; Strings and constants of front/team_grid (src/front/team_grid), in link order.
bits 32
%include "hockey.inc"
section s_C1880 progbits alloc noexec write align=1
global str_Back, str_Callogo2
str_Back:                                       ; string 'back'; used by SaveGridCellBg
        db 062h,061h,063h,06Bh,00h
str_Callogo2:                                   ; string 'callogo'; used by DrawTeamGrid
        db 063h,061h,06Ch,06Ch,06Fh,067h,06Fh,00h
