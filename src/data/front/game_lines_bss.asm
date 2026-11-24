; BSS of front/game_lines (src/front/game_lines).
bits 32
%include "hockey.inc"
section s_EC7E0 nobits alloc noexec write align=1
global lineedpanel, fadepal, fadepal2, blitclipright, blitclipbottom, blitcliptop, blitclipleft, gamelinespal
global gmroster, gmrosterjersey, gmrosterslot, gmrosterpos, gmrosterdot, gmrosterspace, gmrostername
lineedpanel:                                    ; roster panel of the line editor; used by DbLineEditor,
                                                ; ShowRosterStats
        resb 4
fadepal:                                        ; 300h working palette of FadePalStep; used by FadePalStep
        resb 768
fadepal2:                                       ; 300h working palette of FadePalStepSlow; used by
                                                ; FadePalStepSlow
        resb 768
blitclipright:                                  ; BlitClipRect: x >= this rejects, x+w clamped to it; used by
                                                ; BlitClipRect
        resb 4
blitclipbottom:                                 ; BlitClipRect: y >= this rejects, y+h clamped to it; used by
                                                ; BlitClipRect
        resb 4
blitcliptop:                                    ; BlitClipRect: y+h < this rejects, y clamped up to it; used
                                                ; by BlitClipRect
        resb 4
blitclipleft:                                   ; BlitClipRect: x+w < this rejects, x clamped up to it; used
                                                ; by BlitClipRect
        resb 4
gamelinespal:                                   ; game line editor: 768-byte saved palette; used by
                                                ; MenuGameShowPlayerStats
        resb 768
gmroster:                                       ; game line editor roster entries (1Ah bytes): position; used
                                                ; by CheckGameRosterComplete, DrawGameLineJerseys_join,
                                                ; GameDressPlayer ...
        resb 1
gmrosterjersey:                                 ; entry +1 jersey; used by DrawGameLineJerseys_join,
                                                ; GameDressPlayer, GameLineEditorLoop ...
        resb 1
gmrosterslot:                                   ; entry +2 hmroster index; used by CheckGameRosterComplete,
                                                ; DrawGameLineJerseys, GameDressPlayer ...
        resb 1
gmrosterpos:                                    ; Byte 3 of each game roster record (26 bytes): copied from
                                                ; the roster file record; used by LoadGameRoster
        resb 1
gmrosterdot:                                    ; Byte 4 of each game roster record: set to a full stop after
                                                ; the jersey number; used by LoadGameRoster
        resb 1
gmrosterspace:                                  ; Byte 5 of each game roster record: set to a space before the
                                                ; name; used by LoadGameRoster
        resb 1
gmrostername:                                   ; Player name (16 bytes) of each game roster record; used by
                                                ; LoadGameRoster
        resb 610
