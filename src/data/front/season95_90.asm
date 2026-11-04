; Which roster rows are selected, whether the database needs saving, and the edit-rosters messages.
bits 32
%include "hockey.inc"
section s_EA994 nobits alloc noexec write align=1
global byte_EAC86, rostersel, byte_EAF99, byte_EAFB5, dword_EA994, rosterteamrec, dword_EAF7C
global dbdirty, rostergstat, rosterpstat, msglines, dword_EBCA4, editptrspr
global editrosters_exit, unk_EAC84, unk_EAFB8
dword_EA994:
resb 752
unk_EAC84:
resb 2
byte_EAC86:
resb 754
rosterteamrec:
resb 4
dword_EAF7C:
resb 4
rostersel:
resb 25
byte_EAF99:
resb 3
resb 25
byte_EAFB5:
resb 3
unk_EAFB8:
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
dword_EBCA4:
resb 504
editptrspr:
resb 4
editrosters_exit:
resb 2072
