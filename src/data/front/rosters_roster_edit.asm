; Which roster rows are selected, whether the database needs saving, and the edit-rosters messages.
bits 32
%include "hockey.inc"
section s_EA994 nobits alloc noexec write align=1
global roster2slot, rostersel, rosterselgoalies, roster2selgoalies, rosterlistkeys, rosterteamrec, roster2teamrec
global dbdirty, rostergstat, rosterpstat, msglines, falisttop, editptrspr
global editrosters_exit, roster2list, rosterteamcopy
rosterlistkeys:
        resb 752
roster2list:
        resb 2
roster2slot:
        resb 754
rosterteamrec:
        resb 4
roster2teamrec:
        resb 4
rostersel:
        resb 25
rosterselgoalies:
        resb 3
        resb 25
roster2selgoalies:
        resb 3
rosterteamcopy:
        resb 3248
dbdirty:
        resb 4
rostergstat:
        resb 4
rosterpstat:
        resb 4
msglines:
        resb 4
        resb 4
        resb 40
falisttop:
        resb 504
editptrspr:
        resb 4
editrosters_exit:
        resb 2072
