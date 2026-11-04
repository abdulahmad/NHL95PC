; The saved mouse position, the saved palette, and the home team's live struct.
bits 32
%include "hockey.inc"
section s_DF00C nobits alloc noexec write align=1
global savedmousex, savedmousey, hmtmstruct, hmpassatt, hmpasscmp
global savepal, gamepal, hmscore
savedmousex:
resb 4
savedmousey:
resb 4
savepal:
resb 768
gamepal:
resb 766
resb 2
hmtmstruct:
resb 2
resb 2
resb 2
resb 2
resb 2
resb 2
resb 2
resb 2
hmscore:
resb 2
resb 4
resb 12
resb 2
resb 2
hmpassatt:
resb 2
hmpasscmp:
resb 2
