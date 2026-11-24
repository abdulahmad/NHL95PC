; BSS of front/title (src/front/title).
bits 32
%include "hockey.inc"
section s_DC33C nobits alloc noexec write align=1
global titlesample
titlesample:                                    ; TitleScreen: handle of the sample it loads and plays; used
                                                ; by TitleScreen
        resb 4
