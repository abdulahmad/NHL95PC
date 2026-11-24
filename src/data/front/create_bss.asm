; BSS of front/create (src/front/create).
bits 32
%include "hockey.inc"
section s_EA992 nobits alloc noexec write align=1
global rosterslot, rosterstat, rosterlistkeys
rosterslot:                                     ; rosterlist entry +2 roster slot; used by FindRosterSlot,
                                                ; FixJerseyNumber, LineEdDone ...
        resb 1
rosterstat:                                     ; rosterlist entry +3: 2 scratched, 3 dressed; used by
                                                ; CheckRosterComplete, DbLineEditorLoop, DrawLineJerseys ...
        resb 1
rosterlistkeys:                                 ; Player key table read by the roster move and create routines
                                                ; (indexed by two registers); used by MoveToFreeAgents,
                                                ; MoveToOtherRoster, SelectMatchingPlayers
        resb 752
