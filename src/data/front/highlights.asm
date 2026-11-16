; One highlight record: the teams, the clock, and where the replay starts.
bits 32
%include "hockey.inc"
section s_E03C4 nobits alloc noexec write align=1
global hilightrec
global ReplayBuffer
hilightrec:
        resb 1
        resb 1
        resb 1
        resb 28
        resb 1
        resb 28
        resb 4
        resb 4
        resb 4
        resb 4
        resb 2
        resb 4
ReplayBuffer:
        resb 38395
