; A few words at the start of the per-player stat lines.
bits 32
%include "hockey.inc"
section s_DB08A nobits alloc noexec write align=1
global hmplstats_w2, hmplstats_w4, hmplstats_w6, hmplstats_w8, hmplstats_w10, hmplstats_w12, hmplstats_w14
hmplstats_w2:
        resb 2
hmplstats_w4:
        resb 2
hmplstats_w6:
        resb 2
hmplstats_w8:
        resb 2
hmplstats_w10:
        resb 2
hmplstats_w12:
        resb 2
hmplstats_w14:
        resb 386
