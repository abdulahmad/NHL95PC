; Strings and constants of pc/database_merge (src/pc/database_merge), in link order.
bits 32
%include "hockey.inc"
section s_C1904 progbits alloc noexec write align=1
global str_02d2, str_SAV2, str_GAME2
str_02d2:                                       ; string '.%02d'; used by MergeLeagueFiles
        db 02Eh,025h,030h,032h,064h,00h
str_SAV2:                                       ; string 'SAV'; used by RebuildLeagueDbs
        db 053h,041h,056h,00h
str_GAME2:                                      ; string 'GAME'; used by RebuildLeagueDbs
        db 047h,041h,04Dh,045h,00h,00h
