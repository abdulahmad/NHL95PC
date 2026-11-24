; BSS of pc/database_merge (src/pc/database_merge).
bits 32
%include "hockey.inc"
section s_DDD70 nobits alloc noexec write align=1
global lgplayeridfile
lgplayeridfile:                                 ; PLAYER.ID exists in the league dir (floppy player copy, not
                                                ; master); used by MergeLeagueFiles, MergeUpdateDbs
        resb 4
