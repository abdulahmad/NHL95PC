; The away goalie, the scratches, and the path of the game summary.
bits 32
%include "hockey.inc"
section s_D9A38 nobits alloc noexec write align=1
global awgoalieidx, awscratch, gsummarypath, photoptrs, awlinetab
photoptrs:
resb 4536
awlinetab:
resb 36
awgoalieidx:
resb 1
resb 3
awscratch:
resb 8
gsummarypath:
resb 32
