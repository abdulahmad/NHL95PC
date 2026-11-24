; BSS of front/desk (src/front/desk).
bits 32
%include "hockey.inc"
section s_DC868 nobits alloc noexec write align=1
global otherperiodprev, deskptry, deskptrx, deskbankname
otherperiodprev:                                ; Copy of otherperiod (six dwords) used by the intermission
                                                ; desk to spot changes
        resb 32
deskptry:                                       ; used by MenuSaveGame, SportsDesk
        resb 4
deskptrx:                                       ; used by MenuSaveGame, SportsDesk
        resb 4
deskbankname:                                   ; SportsDesk: 'EADESK%1d' bank name buffer; used by
                                                ; LoadCrestsPalette, SportsDesk
        resb 16
