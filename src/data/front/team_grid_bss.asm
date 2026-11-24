; BSS of front/team_grid (src/front/team_grid).
bits 32
%include "hockey.inc"
section s_DDD68 nobits alloc noexec write align=1
global gridcelly, gridcellx
gridcelly:                                      ; string ''; used by RestoreGridCellBg, SaveGridCellBg
        resb 4
gridcellx:                                      ; string ''; used by RestoreGridCellBg, SaveGridCellBg
        resb 4
