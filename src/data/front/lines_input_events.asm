; The roster the line editor is showing, and the queue of mouse and key events.
bits 32
%include "hockey.inc"
section s_EA0DC nobits alloc noexec write align=1
global ctlavailmask, rosterlist, rosterjersey, rosterslot
global rosterstat, ptrupdatefn, inputqueue, lastinputdir, inputrepeat, inputev
global RosterFont, fullscrbmp, rosterteamptr, tmpdbpath
ptrupdatefn:
        resb 24
ctlavailmask:
        resb 4
inputqueue:
        resb 4
        resb 1
        resb 4
        resb 407
lastinputdir:
        resb 4
inputrepeat:
        resb 4
inputev:
        resb 4
        resb 1
        resb 4
        resb 7
RosterFont:
        resb 4
fullscrbmp:
        resb 1716
tmpdbpath:
        resb 32
rosterteamptr:
        resb 8
rosterlist:
        resb 1
rosterjersey:
        resb 1
rosterslot:
        resb 1
rosterstat:
        resb 1
