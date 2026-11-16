; The roster the line editor is showing, and the queue of mouse and key events.
bits 32
%include "hockey.inc"
section s_EA0DC nobits alloc noexec write align=1
global ctlavailmask, rosterlist, rosterjersey, rosterslot
global rosterstat, ptrupdatefn, inputqueue, lastinputdir, inputrepeat, inputev
global RosterFont, fullscrbmp, rosterteamptr, tmpdbpath
ptrupdatefn:                                    ; event -> pointer callback (EventToPointer); used by
                                                ; CalendarScreen, ControlsDlgLoop, CreatePlayerLoop ...
        resb 24
ctlavailmask:                                   ; available control devices bit mask (1/2/4/8); LoadModeState
                                                ; drops ctl1dev / ctl2dev not present; used by
                                                ; AnyInputPressed, CreatePlayoffs, DrawControlsOpts ...
        resb 4
inputqueue:                                     ; [32] 13-byte events: type, buttons +4, dir / x +5, y +9;
                                                ; used by GetInputEvent, InputPollTick
        resb 4
        resb 1
        resb 4
        resb 407
lastinputdir:                                   ; string ''; used by InputPollTick
        resb 4
inputrepeat:                                    ; ticks the same direction is held; used by EventToPointer,
                                                ; InputPollTick
        resb 4
inputev:                                        ; event being polled; used by InputPollTick
        resb 4
        resb 1
        resb 4
        resb 7
RosterFont:                                     ; Font the roster editor saves from mainfont; used by
                                                ; RunEditRosters
        resb 4
fullscrbmp:                                     ; 640x480 bitmap allocated in database_save init (CreateBitmap
                                                ; 280h,1E0h); passed to SetDrawBitmap by editors/stat screens;
                                                ; used by DbLineEditor, DrawCreatePlayer, DrawDBErrorsScreen
                                                ; ...
        resb 1716
tmpdbpath:                                      ; roster editor: path buffer of the temporary databases; used
                                                ; by CreateFreeAgent, DeleteTempDatabases, LoadTempDatabases
        resb 32
rosterteamptr:                                  ; [2] team record pointer per roster panel; used by
                                                ; DrawRosterTitle, LoadRosterList_team
        resb 8
rosterlist:                                     ; player lists of the two team panels, 1Ch entries of 1Bh
                                                ; bytes (2F4h) each; used by CheckRosterComplete,
                                                ; DbLineEditorLoop, DrawLineJerseys ...
        resb 1
rosterjersey:                                   ; rosterlist entry +1 jersey; used by DbLineEditorLoop,
                                                ; DrawLineJerseys, DrawRosterList ...
        resb 1
rosterslot:                                     ; rosterlist entry +2 roster slot; used by FindRosterSlot,
                                                ; FixJerseyNumber, LineEdDone ...
        resb 1
rosterstat:                                     ; rosterlist entry +3: 2 scratched, 3 dressed; used by
                                                ; CheckRosterComplete, DbLineEditorLoop, DrawLineJerseys ...
        resb 1
