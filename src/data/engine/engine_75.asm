; Per-player stat lines for the game in progress.
bits 32
%include "hockey.inc"
section s_DAC40 nobits alloc noexec write align=1
global hmplattr_b13, awplattr_b13, hmplstats_m2, hmplstats, hmglattr, awglattr, hmplattr, awplattr
hmglattr:
resb 48
awglattr:
resb 48
hmplattr:
resb 19
hmplattr_b13:
resb 481
awplattr:
resb 19
awplattr_b13:
resb 479
hmplstats_m2:
resb 2
hmplstats:
resb 2
