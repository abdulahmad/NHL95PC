; Tables for the EA libraries: the mouse, the clip rectangle, and the file and video state.
bits 32
%include "hockey.inc"
section s_D2C84 progbits alloc noexec write align=1
extern __null_int23_exit_, memlist1, BiosKeyCall, ReturnZero, ExitProgram, bcopy, PollHotkeys, str_Jan
extern str_Feb2, str_Mar, str_Apr, str_May2, str_Jun, str_Jul, str_Aug, str_Sep
extern str_Oct, str_Nov, str_Dec
global str_StackOverflow, str_OpenhandleSFILEERROR, CapsLockState, KeyStateTable
global KeyMapNormal, KeyMapShift, KeyMapCaps, KeyMapCtrl, KeyMapAlt, joyenablemask, cpuinfo_b0
global cpuinfo_b1, JoyButtonBits, JoyPortMask, JoyButtons, JoyButtonsPrev, JoyDirection, joyedgedir, SndInitDone
global SndBigEndian, JoyRawButtons, Joy1RawDirection, Joy2RawDirection, JoyDirLookup, TextFirstChar, TextLastChar, TextCharW
global TextCharH, TextSpacing, TextFontH, TextFontAscent, ColourRemap, ResourceArchiveName, DebugRow, DebugBackColor
global DebugTabWidth, __8087, FpuType, BiosKeyFunc, KeyBuffer, KeyBufferHead, KeyBufferTail, KeyBufferMask
global SavedKbdVecOffset, SavedInt16Offset, SavedRealKbdOffset, memblocklist, RowTableSize, RowTableBuffer, FreeSpaceList, FatalErrorHook
global StartupCs, StartupDs, MemDescriptorsEnd, MemDescriptors, SnapFormat, VesaProbed, ModeWidthTable, ModeHeightTable
global joycalactive, tickcount, slowtickcount, oldint8off, mouseminx, mouseminy, mousemaxx, mousemaxy
global MouseDeltaX, MouseButtonState, MouseForceTwoButtons, GraphicsReady, MousePresent, mousex, mousey, mousebtns
global PointerCount, MouseButtons, ViewScreenWidth, ViewScreenHeight, ViewMarginX, ViewMarginY, ViewMaxX, ViewMaxY
global cpuinfo_d0, cpuinfo_d1, SavedBreakOffset, BreakCallFunc, ScreenWidth, ScreenHeight, cliprect_x0, cliprect_y0
global cliprect_x1, cliprect_y1, DrawClipLeft, DrawClipRight, DrawRowBytes, KeyedDraw, DrawDestBuffer, DrawVideoBase
global BackBufferWidth, ScreenBmHeight, ScreenBmClipX0, ScreenBmClipY0, ScreenBmClipX1, ScreenBmClipY1, ScreenBmOffset, ScreenBmRowBytes
global ScreenBmPitch, ScreenBmBanked, ScreenRowTable, PutBlockScaleSteps, JoyRawX1, JoyRawY1, JoyRawX2, JoyRawY2
global JoyAxisY2, JoyAxisMask, JoyX1Threshold, JoyX1Min, JoyX1Center, JoyX1Max, JoyX1Settle, JoyY1Min
global JoyY1Max, JoyY1Threshold, JoyY1MinSeen, JoyY1Center, JoyY1MaxSeen, JoyY1Settle, JoyX2Min, JoyX2Max
global JoyXScale, JoyYScale, SampleChunkSize, PlayPatchHandle, bailout_vec, FpuFlags, Joy2RawX, Joy2RawY
global Joy2XMin, Joy2XMax, Joy2XCenter, Joy2XSettle, Joy2XMinSeen, Joy2XMaxSeen, Joy2YMin, Joy2YMax
global Joy2YCenter, Joy2YSettle, Joy2YMinSeen, Joy2YMaxSeen, Joy2XScale, Joy2YScale, Joy1RawX, Joy1RawY
global Joy1XMin, Joy1XMax, Joy1XCenter, Joy1XSettle, Joy1XMinSeen, Joy1XMaxSeen, Joy1YMin, Joy1YMax
global Joy1YCenter, Joy1YSettle, Joy1YMinSeen, Joy1YMaxSeen, Joy1XScale, Joy1YScale, tickdeadline, ticklast
global RetraceTimeout, fontcolor, TextBackColor, TextOriginX, TextOriginY, TextShadowOn, TextFontTag, TextWidthTable
global TextCursorX, TextCursorY, TextLeft, TextTop, TextRight, TextBottom, RowCopyFunc, HeapList
global HeapRover, HeapLargestFree, ArchiveHandle, ArchiveOpenFn, ArchiveCount, ResourceArchive, FindFilePtr, SlowDeadline
global DebugMode, DebugScreenBase, DebugLineWidth, DebugLogOn, MemViewBlack, MemViewWhite, MemViewYellow, MemViewGreen
global MemViewRed, MemViewShowDetail, MemViewOpen, MemViewCursor, MemViewRowY, MemViewRowX, PaletteCursorColours, DebugLastKey
global ExitHook, Int23Hook, FpuExitHook, HidePointerKeepHook, HidePointerHook, ShowPointerHook, mousepollfn, UnpackedSizeHook
global UnpackHook, KbdIdleHook, TextFont, joycalprehook, joycalposthook, randseed, DefaultSampleInfo, FindFileDta
global FindFileName, FindFilePattern, DefaultFont, DefaultFontOffsets, DefaultFontWidths, SavedKbdVecSelector, SavedInt16Selector, SavedRealKbdSegment
global KbdDataSelector, saved_ss, oldint8sel, MouseSavedSensX, MouseSavedSensY, MouseSavedThreshold, SavedBreakSelector, BreakDataSelector
global EmuHookFlags, SavedEsSelector
BiosKeyFunc:                                    ; used by InstallKeyboardHandler, KbdGetKey, KbdPeekKey ...
        dd BiosKeyCall
        db 00h,00h,00h,00h
KeyBuffer:                                      ; used by Int16Service, KeyboardIrqHandler
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
KeyBufferHead:                                  ; used by Int16Service, KeyboardIrqHandler
        db 00h,00h,00h,00h
KeyBufferTail:                                  ; used by Int16Service
        db 00h,00h,00h,00h
CapsLockState:                                  ; Caps Lock on/off; toggled by the keyboard handler which also
                                                ; sets the LED; used by KeyboardIrqHandler
        db 00h,00h,00h,00h
KeyBufferMask:                                  ; used by Int16Service, KeyboardIrqHandler
        db 01h,00h,00h,00h
KeyStateTable:                                  ; used by Int16Service, KeyDown, KeyboardIrqHandler
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
SavedKbdVecOffset:                              ; Previous keyboard interrupt offset; used by
                                                ; InstallKeyboardHandler, RemoveKeyboardHandler
        db 00h,00h,00h,00h
SavedKbdVecSelector:                            ; Previous keyboard interrupt selector; used by
                                                ; InstallKeyboardHandler, RemoveKeyboardHandler
        db 00h,00h
SavedInt16Offset:                               ; Previous INT 16h offset; used by InstallKeyboardHandler,
                                                ; RemoveKeyboardHandler
        db 00h,00h,00h,00h
SavedInt16Selector:                             ; Previous INT 16h selector; used by InstallKeyboardHandler,
                                                ; RemoveKeyboardHandler
        db 00h,00h
SavedRealKbdOffset:                             ; Previous real mode keyboard handler offset; used by
                                                ; InstallKeyboardHandler, RemoveKeyboardHandler
        db 00h,00h,00h,00h
SavedRealKbdSegment:                            ; Previous real mode keyboard handler segment; used by
                                                ; InstallKeyboardHandler, RemoveKeyboardHandler
        db 00h,00h
KbdDataSelector:                                ; Data selector used by the keyboard handler
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0FFh,0FFh,00h,00h
KeyMapNormal:                                   ; Scan code to ASCII with no shift key down; used by
                                                ; KeyboardIrqHandler
        db 00h,01Bh,031h,032h,033h,034h,035h,036h,037h,038h,039h,030h,02Dh,03Dh,08h,09h
        db 071h,077h,065h,072h,074h,079h,075h,069h,06Fh,070h,05Bh,05Dh,0Dh,00h,061h,073h
        db 064h,066h,067h,068h,06Ah,06Bh,06Ch,03Bh,027h,060h,00h,05Ch,07Ah,078h,063h,076h
        db 062h,06Eh,06Dh,02Ch,02Eh,02Fh,00h,02Ah,00h,020h,00h,0BBh,0BCh,0BDh,0BEh,0BFh
        db 0C0h,0C1h,0C2h,0C3h,0C4h,00h,00h,0C7h,0C8h,0C9h,02Dh,0CBh,0CCh,0CDh,02Bh,0CFh
        db 0D0h,0D1h,0D2h,0D3h,00h,00h,00h,087h,088h,00h,00h
KeyMapShift:                                    ; Scan code to ASCII with Shift down; used by
                                                ; KeyboardIrqHandler
        db 00h,01Bh,021h,040h,023h,024h,025h,05Eh,026h,02Ah,028h,029h,05Fh,02Bh,08h,08Fh
        db 051h,057h,045h,052h,054h,059h,055h,049h,04Fh,050h,07Bh,07Dh,0Dh,00h,041h,053h
        db 044h,046h,047h,048h,04Ah,04Bh,04Ch,03Ah,022h,07Eh,00h,07Ch,05Ah,058h,043h,056h
        db 042h,04Eh,04Dh,03Ch,03Eh,03Fh,00h,00h,00h,020h,00h,0D4h,0D5h,0D6h,0D7h,0D8h
        db 0D9h,0DAh,0DBh,0DCh,0DDh,00h,00h,0C7h,0C8h,0C9h,02Dh,0CBh,0CCh,0CDh,02Bh,0CFh
        db 0D0h,0D1h,0D2h,0D3h,00h,00h,00h,089h,08Ah,00h,00h
KeyMapCaps:                                     ; Scan code to ASCII with Caps Lock on; used by
                                                ; KeyboardIrqHandler
        db 00h,01Bh,031h,032h,033h,034h,035h,036h,037h,038h,039h,030h,02Dh,03Dh,08h,08Fh
        db 051h,057h,045h,052h,054h,059h,055h,049h,04Fh,050h,05Bh,05Dh,0Dh,00h,041h,053h
        db 044h,046h,047h,048h,04Ah,04Bh,04Ch,03Bh,027h,060h,00h,05Ch,05Ah,058h,043h,056h
        db 042h,04Eh,04Dh,02Ch,02Eh,02Fh,00h,00h,00h,020h,00h,0D4h,0D5h,0D6h,0D7h,0D8h
        db 0D9h,0DAh,0DBh,0DCh,0DDh,00h,00h,0C7h,0C8h,0C9h,02Dh,0CBh,0CCh,0CDh,02Bh,0CFh
        db 0D0h,0D1h,0D2h,0D3h,00h,00h,00h,089h,08Ah,00h,00h
KeyMapCtrl:                                     ; Scan code to ASCII with Ctrl down; used by
                                                ; KeyboardIrqHandler
        db 00h,01Bh,021h,00h,023h,024h,025h,01Eh,026h,02Ah,028h,029h,01Fh,0B3h,07Fh,09h
        db 011h,017h,05h,012h,014h,019h,015h,09h,0Fh,010h,01Bh,01Dh,0Dh,00h,01h,013h
        db 04h,06h,07h,08h,0Ah,0Bh,0Ch,03Bh,02Ch,060h,00h,01Ch,01Ah,018h,03h,016h
        db 02h,0Eh,0B2h,03Ch,03Eh,03Fh,00h,00h,00h,020h,00h,0DEh,0DFh,0E0h,0E1h,0E2h
        db 0E3h,0E4h,0E5h,0E6h,0E7h,00h,00h,0C7h,0C8h,0C9h,02Dh,0CBh,0CCh,0CDh,02Bh,0CFh
        db 0D0h,0D1h,0D2h,0D3h,00h,00h,00h,08Bh,08Ch,00h,00h
KeyMapAlt:                                      ; Scan code to key code with Alt down; used by
                                                ; KeyboardIrqHandler
        db 00h,01Bh,021h,040h,023h,024h,025h,05Eh,026h,02Ah,028h,029h,05Fh,02Bh,08h,08Fh
        db 090h,091h,092h,093h,094h,095h,096h,097h,098h,099h,07Bh,07Dh,0Dh,00h,09Eh,09Fh
        db 0A0h,0A1h,0A2h,0A3h,0A4h,0A5h,0A6h,03Ah,022h,07Eh,00h,07Ch,0ACh,0ADh,0AEh,0AFh
        db 0B0h,0B1h,0B2h,03Ch,03Eh,03Fh,00h,00h,00h,020h,00h,0F8h,0F9h,0FAh,0FBh,0FCh
        db 0FDh,0FEh,0FFh,080h,081h,00h,00h,0C7h,0C8h,0C9h,02Dh,0CBh,0CCh,0CDh,02Bh,0CFh
        db 0D0h,0D1h,0D2h,0D3h,00h,00h,00h,08Dh,08Eh,00h,00h,00h
saved_ss:                                       ; SS saved by SaveSS; used by SaveSS, __STK
        db 00h,00h
str_StackOverflow:                              ; "Stack Overflow!\r\n" string literal; used by __STKOVF
        db 053h,074h,061h,063h,06Bh,020h,04Fh,076h,065h,072h,066h,06Ch,06Fh,077h,021h,0Dh
        db 0Ah,00h
memblocklist:                                   ; EA memory manager: the block list the port checks a pointer
                                                ; against before FreeMemBlock; used by CompactDownLocked,
                                                ; CompactUpLocked, FindCachedFile ...
        dd memlist1
RowTableSize:                                   ; Number of entries in the screen row table buffer (default
                                                ; 0E00h; at least 0CCh); used by SetRowTableBuffer, initmemman
        db 00h,0Eh,00h,00h
RowTableBuffer:                                 ; Buffer for screen row tables; defaults to the static buffer;
                                                ; used by FillRowTable, SetRowTableBuffer, initmemman ...
        db 00h,00h,00h,00h
FreeSpaceList:                                  ; used by FindFreeSpace, MergeFreeSpace, reservemem
        db 00h,00h,00h,00h
ExitHook:                                       ; used by atexit_, exit_
        dd __null_int23_exit_
Int23Hook:                                      ; used by _exit_, exit_
        dd __null_int23_exit_
FpuExitHook:                                    ; FPU shutdown routine called at exit; used by _exit_
        dd __null_int23_exit_
FatalErrorHook:                                 ; Routine FatalError returns into instead of the boxed
                                                ; message; used by FatalError, FatalErrorEnd
        db 00h,00h,00h,00h
StartupCs:                                      ; Code selector shown by the memory viewer; used by
                                                ; MemViewerDrawList
        db 00h,00h
StartupDs:                                      ; Data selector shown by the memory viewer; used by
                                                ; MemViewerDrawList
        db 00h,00h
MemDescriptorsEnd:                              ; End of the memory descriptor array; used by initmemman
        db 00h,00h,00h,00h
MemDescriptors:                                 ; Memory descriptor array allocated by initmemman; used by
                                                ; MemViewerDrawTitle, initgraphics, initmemman
        db 00h,00h,00h,00h
SnapFormat:                                     ; Screenshot format; 7 selects the alternate layout; used by
                                                ; SnapScreenToShape
        db 06h,00h,00h,00h
VesaProbed:                                     ; Set once the VESA BIOS has been probed; used by initgraphics
        db 00h,00h,00h,00h
ModeWidthTable:                                 ; Screen width per video mode (8-byte entries with the
                                                ; height); used by initgraphics
        db 080h,02h,00h,00h
ModeHeightTable:                                ; Screen height per video mode; used by initgraphics
        db 090h,01h,00h,00h,080h,02h,00h,00h,0E0h,01h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,020h,03h,00h,00h,058h,02h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,04h,00h,00h,00h,03h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,05h,00h,00h,00h,04h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h
joycalactive:                                   ; 1 while JoystickCalScreen runs; used by JoystickCalScreen,
                                                ; ShowMessageBox, ShowPromptBox
        db 00h,00h,00h,00h
tickcount:                                      ; used by GetTicks, ResetTicks, SetTickDeadline ...
        db 00h,00h,00h,00h
slowtickcount:                                  ; used by DebugLineCount, FindNextFile, SetSlowDeadline ...
        db 00h,00h,00h,00h
oldint8off:                                     ; offset of the saved int 08h vector: InstallTimer stores
                                                ; _dos_getvect_(8) eax here, RestoreTimer passes it back to
                                                ; _dos_setvect_, TimerISR far-calls through it with
                                                ; oldint8sel; used by InstallTimer, RestoreTimer, TimerISR
        db 00h,00h,00h,00h
oldint8sel:                                     ; selector of the saved int 08h vector: InstallTimer stores
                                                ; the _dos_getvect_(8) selector (dx) here, RestoreTimer passes
                                                ; it back in cx; used by InstallTimer, RestoreTimer
        db 00h,00h,00h,00h
mouseminx:                                      ; mouse library: pointer range, left; used by MouseReadMotion,
                                                ; MouseSetXRange, SetViewRect
        db 00h,00h,00h,00h
mouseminy:                                      ; mouse library: pointer range, top; used by MouseReadMotion,
                                                ; MouseSetXRange, SetViewRect
        db 00h,00h,00h,00h
mousemaxx:                                      ; mouse library: pointer range, right (exclusive); used by
                                                ; MouseReadMotion, MouseSetXRange, SetViewRect
        db 040h,01h,00h,00h
mousemaxy:                                      ; mouse library: pointer range, bottom (exclusive); used by
                                                ; MouseReadMotion, MouseSetXRange, SetViewRect
        db 0C8h,00h,00h,00h
MouseDeltaX:                                    ; Mouse motion X since the last read; used by MouseReadMotion
        db 00h,00h,00h,00h
MouseButtonState:                               ; used by MouseReadButtons, MouseReadMotion
        db 01h,00h,00h,00h
MouseSavedSensX:                                ; Mouse X sensitivity saved at start up; used by InitMouse,
                                                ; MouseRestoreSensitivity
        db 00h,00h
MouseSavedSensY:                                ; Mouse Y sensitivity saved at start up; used by InitMouse,
                                                ; MouseRestoreSensitivity
        db 00h,00h
MouseSavedThreshold:                            ; Mouse double speed threshold saved at start up; used by
                                                ; InitMouse, MouseRestoreSensitivity
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h
MouseForceTwoButtons:                           ; Treat the mouse as two buttons; used by InitMouse
        db 00h,00h,00h,00h,01h,00h,00h,00h
GraphicsReady:                                  ; used by DumpMemoryMap, FatalError, MemViewer ...
        db 00h,00h,00h,00h
MousePresent:                                   ; used by InitMouse, MouseReadButtons, MouseReadMotion ...
        db 00h,00h,00h,00h
mousex:                                         ; string ''; used by DrawRinkOverlays, EventToPointer,
                                                ; Gameloop ...
        db 00h,00h,00h,00h
mousey:                                         ; string ''; used by DrawRinkOverlays, EventToPointer,
                                                ; Gameloop ...
        db 00h,00h,00h,00h
mousebtns:                                      ; string ''; used by AnyInputPressed, MouseReadMotion,
                                                ; PollMouseEvent ...
        db 00h,00h,00h,00h
PointerCount:                                   ; Pointer show count; used by InitMouse, PointerCountDown,
                                                ; PointerCountUp
        db 00h,00h,00h,00h
MouseButtons:                                   ; Mouse buttons; used by InitMouse
        db 00h,00h,00h,00h
joyenablemask:                                  ; enabled joystick bits (cleared on failed calibration); used
                                                ; by JoyDefaultCalib1, JoyDefaultCalib2, JoyResetCentres ...
        db 00h,00h,00h,00h
ViewScreenWidth:                                ; Width of the current screen mode; used by InitMouse,
                                                ; MemViewerDrawList, ShapeInfo ...
        db 00h,00h,00h,00h
ViewScreenHeight:                               ; Full screen height the game view is sized against; used by
                                                ; InitMouse, MemViewerDrawList, ShapeInfo ...
        db 00h,00h,00h,00h
ViewMarginX:                                    ; Horizontal margin taken off the screen width; used by
                                                ; initgraphics
        db 00h,00h,00h,00h
ViewMarginY:                                    ; Vertical margin taken off the screen height; used by
                                                ; initgraphics
        db 00h,00h,00h,00h
ViewMaxX:                                       ; Screen width less the horizontal margin; used by
                                                ; initgraphics
        db 040h,01h,00h,00h
ViewMaxY:                                       ; Screen height less the vertical margin; used by initgraphics
        db 0C8h,00h,00h,00h
cpuinfo_d0:                                     ; DetectCPU result, first dword (1 on a 486 in protected
                                                ; mode); used by DetectCPU
        db 00h,00h,00h,00h
cpuinfo_d1:                                     ; DetectCPU result, second dword; used by DetectCPU
        db 00h,00h,00h,00h
cpuinfo_b0:                                     ; DetectCPU result, first flag byte; used by DetectCPU
        db 00h,00h,00h,00h
cpuinfo_b1:                                     ; DetectCPU result, second flag byte; used by DetectCPU
        db 00h,00h,00h,00h
HidePointerKeepHook:                            ; Hides the pointer keeping the screen; used by InitMouse,
                                                ; ShowMessageBox, ShowPromptBox
        dd ReturnZero
HidePointerHook:                                ; Hides the pointer; used by InitMouse, ShowMessageBox,
                                                ; ShowPromptBox
        dd ReturnZero
ShowPointerHook:                                ; Shows the pointer; used by InitMouse, ShowMessageBox,
                                                ; ShowPromptBox
        dd ReturnZero
mousepollfn:                                    ; mouse driver poll hook; used by AnyInputPressed,
                                                ; CreatePlayerLoop, EditRosters ...
        dd ReturnZero
        dd ReturnZero
        dd ReturnZero
        dd ReturnZero
UnpackedSizeHook:                               ; Hook asked first for the unpacked size; returns 0 to fall
                                                ; through; used by UnpackedSize
        dd ReturnZero
UnpackHook:                                     ; Hook asked first to unpack; returns 0 to fall through; used
                                                ; by unpack
        dd ReturnZero
SavedBreakOffset:                               ; Previous ctrl-break handler offset; used by
                                                ; InstallBreakHandler, RemoveBreakHandler
        db 00h,00h,00h,00h
SavedBreakSelector:                             ; Previous ctrl-break handler selector; used by
                                                ; InstallBreakHandler, RemoveBreakHandler
        db 00h,00h
BreakCallFunc:                                  ; Ctrl-break chain routine; used by ClearNumLock,
                                                ; InstallBreakHandler
        db 00h,00h,00h,00h
BreakDataSelector:                              ; Data selector for the ctrl-break handler; used by
                                                ; InstallBreakHandler
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
ScreenWidth:                                    ; used by DrawArtOpaque, DrawShapeClippedKeyed, FillRect ...
        db 080h,02h,00h,00h
ScreenHeight:                                   ; Screen height; used by PrintStringAtCursor, ResetClipWindow,
                                                ; SetClipWindow ...
        db 0E0h,01h,00h,00h
cliprect_x0:                                    ; DrawSprite / ea_gfx clip left (0); used by BlitShapeClipped,
                                                ; ClearScreen, DrawArtAnd ...
        db 00h,00h,00h,00h
cliprect_y0:                                    ; clip top (0); used by AndPixelClipped, BlitArt,
                                                ; BlitArtKeyColour ...
        db 00h,00h,00h,00h
cliprect_x1:                                    ; clip right (640); used by BlitShapeClipped, ClearScreen,
                                                ; DrawArtAnd ...
        db 080h,02h,00h,00h
cliprect_y1:                                    ; clip bottom (480); used by AndPixelClipped, BlitArt,
                                                ; BlitArtKeyColour ...
        db 0E0h,01h,00h,00h
DrawClipLeft:                                   ; Left edge of the draw target's clip rectangle; x below it is
                                                ; not drawn; used by AndPixelClipped, BlitArt,
                                                ; BlitArtKeyColour ...
        db 00h,00h,00h,00h
DrawClipRight:                                  ; Right edge of the draw target's clip rectangle (exclusive);
                                                ; used by AndPixelClipped, BlitArt, BlitArtKeyColour ...
        db 080h,02h,00h,00h
DrawRowBytes:                                   ; used by BlitArt, BlitArtKeyColour, BlitArtKeyFF ...
        db 080h,02h,00h,00h
KeyedDraw:                                      ; used by AndPixel, DrawArt, DrawArtAnd ...
        db 00h,00h,00h,00h
DrawDestBuffer:                                 ; used by AndPixel, BlitArt, BlitArtKeyColour ...
        dd ScreenRowTable
DrawVideoBase:                                  ; used by AndPixel, BlitArt, BlitArtKeyColour ...
        db 00h,00h,0Ah,00h
BackBufferWidth:                                ; used by SetScreenTarget, ShowMessageBox, ShowPromptBox ...
        db 080h,02h,00h,00h
ScreenBmHeight:                                 ; Screen bitmap height; used by initgraphics
        db 0E0h,01h,00h,00h
ScreenBmClipX0:                                 ; Screen bitmap clip left; used by initgraphics
        db 00h,00h,00h,00h
ScreenBmClipY0:                                 ; Screen bitmap clip top; used by initgraphics
        db 00h,00h,00h,00h
ScreenBmClipX1:                                 ; Screen bitmap clip right; used by initgraphics
        db 080h,02h,00h,00h
ScreenBmClipY1:                                 ; Screen bitmap clip bottom; used by initgraphics
        db 0E0h,01h,00h,00h
ScreenBmOffset:                                 ; Screen bitmap start offset; used by initgraphics
        db 00h,00h,00h,00h
ScreenBmRowBytes:                               ; Screen bitmap bytes per row; used by initgraphics
        db 080h,02h,00h,00h
ScreenBmPitch:                                  ; Screen bitmap pitch; used by initgraphics
        db 080h,02h,00h,00h
ScreenBmBanked:                                 ; 1 when the screen is a banked VESA mode, 0 for mode 13h;
                                                ; used by initgraphics
        db 00h,00h,00h,00h
        dd ScreenRowTable
        db 00h,00h,0Ah,00h
ScreenRowTable:                                 ; used by AndPixel, DrawArtOpaque, DrawShapeClippedKeyed ...
        db 00h,00h,00h,00h,080h,02h,00h,00h,00h,05h,00h,00h,080h,07h,00h,00h
        db 00h,0Ah,00h,00h,080h,0Ch,00h,00h,00h,0Fh,00h,00h,080h,011h,00h,00h
        db 00h,014h,00h,00h,080h,016h,00h,00h,00h,019h,00h,00h,080h,01Bh,00h,00h
        db 00h,01Eh,00h,00h,080h,020h,00h,00h,00h,023h,00h,00h,080h,025h,00h,00h
        db 00h,028h,00h,00h,080h,02Ah,00h,00h,00h,02Dh,00h,00h,080h,02Fh,00h,00h
        db 00h,032h,00h,00h,080h,034h,00h,00h,00h,037h,00h,00h,080h,039h,00h,00h
        db 00h,03Ch,00h,00h,080h,03Eh,00h,00h,00h,041h,00h,00h,080h,043h,00h,00h
        db 00h,046h,00h,00h,080h,048h,00h,00h,00h,04Bh,00h,00h,080h,04Dh,00h,00h
        db 00h,050h,00h,00h,080h,052h,00h,00h,00h,055h,00h,00h,080h,057h,00h,00h
        db 00h,05Ah,00h,00h,080h,05Ch,00h,00h,00h,05Fh,00h,00h,080h,061h,00h,00h
        db 00h,064h,00h,00h,080h,066h,00h,00h,00h,069h,00h,00h,080h,06Bh,00h,00h
        db 00h,06Eh,00h,00h,080h,070h,00h,00h,00h,073h,00h,00h,080h,075h,00h,00h
        db 00h,078h,00h,00h,080h,07Ah,00h,00h,00h,07Dh,00h,00h,080h,07Fh,00h,00h
        db 00h,082h,00h,00h,080h,084h,00h,00h,00h,087h,00h,00h,080h,089h,00h,00h
        db 00h,08Ch,00h,00h,080h,08Eh,00h,00h,00h,091h,00h,00h,080h,093h,00h,00h
        db 00h,096h,00h,00h,080h,098h,00h,00h,00h,09Bh,00h,00h,080h,09Dh,00h,00h
        db 00h,0A0h,00h,00h,080h,0A2h,00h,00h,00h,0A5h,00h,00h,080h,0A7h,00h,00h
        db 00h,0AAh,00h,00h,080h,0ACh,00h,00h,00h,0AFh,00h,00h,080h,0B1h,00h,00h
        db 00h,0B4h,00h,00h,080h,0B6h,00h,00h,00h,0B9h,00h,00h,080h,0BBh,00h,00h
        db 00h,0BEh,00h,00h,080h,0C0h,00h,00h,00h,0C3h,00h,00h,080h,0C5h,00h,00h
        db 00h,0C8h,00h,00h,080h,0CAh,00h,00h,00h,0CDh,00h,00h,080h,0CFh,00h,00h
        db 00h,0D2h,00h,00h,080h,0D4h,00h,00h,00h,0D7h,00h,00h,080h,0D9h,00h,00h
        db 00h,0DCh,00h,00h,080h,0DEh,00h,00h,00h,0E1h,00h,00h,080h,0E3h,00h,00h
        db 00h,0E6h,00h,00h,080h,0E8h,00h,00h,00h,0EBh,00h,00h,080h,0EDh,00h,00h
        db 00h,0F0h,00h,00h,080h,0F2h,00h,00h,00h,0F5h,00h,00h,080h,0F7h,00h,00h
        db 00h,0FAh,00h,00h,080h,0FCh,00h,00h,00h,0FFh,00h,00h,080h,01h,01h,00h
        db 00h,04h,01h,00h,080h,06h,01h,00h,00h,09h,01h,00h,080h,0Bh,01h,00h
        db 00h,0Eh,01h,00h,080h,010h,01h,00h,00h,013h,01h,00h,080h,015h,01h,00h
        db 00h,018h,01h,00h,080h,01Ah,01h,00h,00h,01Dh,01h,00h,080h,01Fh,01h,00h
        db 00h,022h,01h,00h,080h,024h,01h,00h,00h,027h,01h,00h,080h,029h,01h,00h
        db 00h,02Ch,01h,00h,080h,02Eh,01h,00h,00h,031h,01h,00h,080h,033h,01h,00h
        db 00h,036h,01h,00h,080h,038h,01h,00h,00h,03Bh,01h,00h,080h,03Dh,01h,00h
        db 00h,040h,01h,00h,080h,042h,01h,00h,00h,045h,01h,00h,080h,047h,01h,00h
        db 00h,04Ah,01h,00h,080h,04Ch,01h,00h,00h,04Fh,01h,00h,080h,051h,01h,00h
        db 00h,054h,01h,00h,080h,056h,01h,00h,00h,059h,01h,00h,080h,05Bh,01h,00h
        db 00h,05Eh,01h,00h,080h,060h,01h,00h,00h,063h,01h,00h,080h,065h,01h,00h
        db 00h,068h,01h,00h,080h,06Ah,01h,00h,00h,06Dh,01h,00h,080h,06Fh,01h,00h
        db 00h,072h,01h,00h,080h,074h,01h,00h,00h,077h,01h,00h,080h,079h,01h,00h
        db 00h,07Ch,01h,00h,080h,07Eh,01h,00h,00h,081h,01h,00h,080h,083h,01h,00h
        db 00h,086h,01h,00h,080h,088h,01h,00h,00h,08Bh,01h,00h,080h,08Dh,01h,00h
        db 00h,090h,01h,00h,080h,092h,01h,00h,00h,095h,01h,00h,080h,097h,01h,00h
        db 00h,09Ah,01h,00h,080h,09Ch,01h,00h,00h,09Fh,01h,00h,080h,0A1h,01h,00h
        db 00h,0A4h,01h,00h,080h,0A6h,01h,00h,00h,0A9h,01h,00h,080h,0ABh,01h,00h
        db 00h,0AEh,01h,00h,080h,0B0h,01h,00h,00h,0B3h,01h,00h,080h,0B5h,01h,00h
        db 00h,0B8h,01h,00h,080h,0BAh,01h,00h,00h,0BDh,01h,00h,080h,0BFh,01h,00h
        db 00h,0C2h,01h,00h,080h,0C4h,01h,00h,00h,0C7h,01h,00h,080h,0C9h,01h,00h
        db 00h,0CCh,01h,00h,080h,0CEh,01h,00h,00h,0D1h,01h,00h,080h,0D3h,01h,00h
        db 00h,0D6h,01h,00h,080h,0D8h,01h,00h,00h,0DBh,01h,00h,080h,0DDh,01h,00h
        db 00h,0E0h,01h,00h,080h,0E2h,01h,00h,00h,0E5h,01h,00h,080h,0E7h,01h,00h
        db 00h,0EAh,01h,00h,080h,0ECh,01h,00h,00h,0EFh,01h,00h,080h,0F1h,01h,00h
        db 00h,0F4h,01h,00h,080h,0F6h,01h,00h,00h,0F9h,01h,00h,080h,0FBh,01h,00h
        db 00h,0FEh,01h,00h,080h,00h,02h,00h,00h,03h,02h,00h,080h,05h,02h,00h
        db 00h,08h,02h,00h,080h,0Ah,02h,00h,00h,0Dh,02h,00h,080h,0Fh,02h,00h
        db 00h,012h,02h,00h,080h,014h,02h,00h,00h,017h,02h,00h,080h,019h,02h,00h
        db 00h,01Ch,02h,00h,080h,01Eh,02h,00h,00h,021h,02h,00h,080h,023h,02h,00h
        db 00h,026h,02h,00h,080h,028h,02h,00h,00h,02Bh,02h,00h,080h,02Dh,02h,00h
        db 00h,030h,02h,00h,080h,032h,02h,00h,00h,035h,02h,00h,080h,037h,02h,00h
        db 00h,03Ah,02h,00h,080h,03Ch,02h,00h,00h,03Fh,02h,00h,080h,041h,02h,00h
        db 00h,044h,02h,00h,080h,046h,02h,00h,00h,049h,02h,00h,080h,04Bh,02h,00h
        db 00h,04Eh,02h,00h,080h,050h,02h,00h,00h,053h,02h,00h,080h,055h,02h,00h
        db 00h,058h,02h,00h,080h,05Ah,02h,00h,00h,05Dh,02h,00h,080h,05Fh,02h,00h
        db 00h,062h,02h,00h,080h,064h,02h,00h,00h,067h,02h,00h,080h,069h,02h,00h
        db 00h,06Ch,02h,00h,080h,06Eh,02h,00h,00h,071h,02h,00h,080h,073h,02h,00h
        db 00h,076h,02h,00h,080h,078h,02h,00h,00h,07Bh,02h,00h,080h,07Dh,02h,00h
        db 00h,080h,02h,00h,080h,082h,02h,00h,00h,085h,02h,00h,080h,087h,02h,00h
        db 00h,08Ah,02h,00h,080h,08Ch,02h,00h,00h,08Fh,02h,00h,080h,091h,02h,00h
        db 00h,094h,02h,00h,080h,096h,02h,00h,00h,099h,02h,00h,080h,09Bh,02h,00h
        db 00h,09Eh,02h,00h,080h,0A0h,02h,00h,00h,0A3h,02h,00h,080h,0A5h,02h,00h
        db 00h,0A8h,02h,00h,080h,0AAh,02h,00h,00h,0ADh,02h,00h,080h,0AFh,02h,00h
        db 00h,0B2h,02h,00h,080h,0B4h,02h,00h,00h,0B7h,02h,00h,080h,0B9h,02h,00h
        db 00h,0BCh,02h,00h,080h,0BEh,02h,00h,00h,0C1h,02h,00h,080h,0C3h,02h,00h
        db 00h,0C6h,02h,00h,080h,0C8h,02h,00h,00h,0CBh,02h,00h,080h,0CDh,02h,00h
        db 00h,0D0h,02h,00h,080h,0D2h,02h,00h,00h,0D5h,02h,00h,080h,0D7h,02h,00h
        db 00h,0DAh,02h,00h,080h,0DCh,02h,00h,00h,0DFh,02h,00h,080h,0E1h,02h,00h
        db 00h,0E4h,02h,00h,080h,0E6h,02h,00h,00h,0E9h,02h,00h,080h,0EBh,02h,00h
        db 00h,0EEh,02h,00h,080h,0F0h,02h,00h,00h,0F3h,02h,00h,080h,0F5h,02h,00h
        db 00h,0F8h,02h,00h,080h,0FAh,02h,00h,00h,0FDh,02h,00h,080h,0FFh,02h,00h
        db 00h,02h,03h,00h,080h,04h,03h,00h,00h,07h,03h,00h,080h,09h,03h,00h
        db 00h,0Ch,03h,00h,080h,0Eh,03h,00h,00h,011h,03h,00h,080h,013h,03h,00h
        db 00h,016h,03h,00h,080h,018h,03h,00h,00h,01Bh,03h,00h,080h,01Dh,03h,00h
        db 00h,020h,03h,00h,080h,022h,03h,00h,00h,025h,03h,00h,080h,027h,03h,00h
        db 00h,02Ah,03h,00h,080h,02Ch,03h,00h,00h,02Fh,03h,00h,080h,031h,03h,00h
        db 00h,034h,03h,00h,080h,036h,03h,00h,00h,039h,03h,00h,080h,03Bh,03h,00h
        db 00h,03Eh,03h,00h,080h,040h,03h,00h,00h,043h,03h,00h,080h,045h,03h,00h
        db 00h,048h,03h,00h,080h,04Ah,03h,00h,00h,04Dh,03h,00h,080h,04Fh,03h,00h
        db 00h,052h,03h,00h,080h,054h,03h,00h,00h,057h,03h,00h,080h,059h,03h,00h
        db 00h,05Ch,03h,00h,080h,05Eh,03h,00h,00h,061h,03h,00h,080h,063h,03h,00h
        db 00h,066h,03h,00h,080h,068h,03h,00h,00h,06Bh,03h,00h,080h,06Dh,03h,00h
        db 00h,070h,03h,00h,080h,072h,03h,00h,00h,075h,03h,00h,080h,077h,03h,00h
        db 00h,07Ah,03h,00h,080h,07Ch,03h,00h,00h,07Fh,03h,00h,080h,081h,03h,00h
        db 00h,084h,03h,00h,080h,086h,03h,00h,00h,089h,03h,00h,080h,08Bh,03h,00h
        db 00h,08Eh,03h,00h,080h,090h,03h,00h,00h,093h,03h,00h,080h,095h,03h,00h
        db 00h,098h,03h,00h,080h,09Ah,03h,00h,00h,09Dh,03h,00h,080h,09Fh,03h,00h
        db 00h,0A2h,03h,00h,080h,0A4h,03h,00h,00h,0A7h,03h,00h,080h,0A9h,03h,00h
        db 00h,0ACh,03h,00h,080h,0AEh,03h,00h,00h,0B1h,03h,00h,080h,0B3h,03h,00h
        db 00h,0B6h,03h,00h,080h,0B8h,03h,00h,00h,0BBh,03h,00h,080h,0BDh,03h,00h
        db 00h,0C0h,03h,00h,080h,0C2h,03h,00h,00h,0C5h,03h,00h,080h,0C7h,03h,00h
        db 00h,0CAh,03h,00h,080h,0CCh,03h,00h,00h,0CFh,03h,00h,080h,0D1h,03h,00h
        db 00h,0D4h,03h,00h,080h,0D6h,03h,00h,00h,0D9h,03h,00h,080h,0DBh,03h,00h
        db 00h,0DEh,03h,00h,080h,0E0h,03h,00h,00h,0E3h,03h,00h,080h,0E5h,03h,00h
        db 00h,0E8h,03h,00h,080h,0EAh,03h,00h,00h,0EDh,03h,00h,080h,0EFh,03h,00h
        db 00h,0F2h,03h,00h,080h,0F4h,03h,00h,00h,0F7h,03h,00h,080h,0F9h,03h,00h
        db 00h,0FCh,03h,00h,080h,0FEh,03h,00h,00h,01h,04h,00h,080h,03h,04h,00h
        db 00h,06h,04h,00h,080h,08h,04h,00h,00h,0Bh,04h,00h,080h,0Dh,04h,00h
        db 00h,010h,04h,00h,080h,012h,04h,00h,00h,015h,04h,00h,080h,017h,04h,00h
        db 00h,01Ah,04h,00h,080h,01Ch,04h,00h,00h,01Fh,04h,00h,080h,021h,04h,00h
        db 00h,024h,04h,00h,080h,026h,04h,00h,00h,029h,04h,00h,080h,02Bh,04h,00h
        db 00h,02Eh,04h,00h,080h,030h,04h,00h,00h,033h,04h,00h,080h,035h,04h,00h
        db 00h,038h,04h,00h,080h,03Ah,04h,00h,00h,03Dh,04h,00h,080h,03Fh,04h,00h
        db 00h,042h,04h,00h,080h,044h,04h,00h,00h,047h,04h,00h,080h,049h,04h,00h
        db 00h,04Ch,04h,00h,080h,04Eh,04h,00h,00h,051h,04h,00h,080h,053h,04h,00h
        db 00h,056h,04h,00h,080h,058h,04h,00h,00h,05Bh,04h,00h,080h,05Dh,04h,00h
        db 00h,060h,04h,00h,080h,062h,04h,00h,00h,065h,04h,00h,080h,067h,04h,00h
        db 00h,06Ah,04h,00h,080h,06Ch,04h,00h,00h,06Fh,04h,00h,080h,071h,04h,00h
        db 00h,074h,04h,00h,080h,076h,04h,00h,00h,079h,04h,00h,080h,07Bh,04h,00h
        db 00h,07Eh,04h,00h,080h,080h,04h,00h,00h,083h,04h,00h,080h,085h,04h,00h
        db 00h,088h,04h,00h,080h,08Ah,04h,00h,00h,08Dh,04h,00h,080h,08Fh,04h,00h
        db 00h,092h,04h,00h,080h,094h,04h,00h,00h,097h,04h,00h,080h,099h,04h,00h
        db 00h,09Ch,04h,00h,080h,09Eh,04h,00h,00h,0A1h,04h,00h,080h,0A3h,04h,00h
        db 00h,0A6h,04h,00h,080h,0A8h,04h,00h,00h,0ABh,04h,00h,080h,0ADh,04h,00h
        db 00h,0B0h,04h,00h,080h,0B2h,04h,00h,00h,0B5h,04h,00h,080h,0B7h,04h,00h
        db 00h,0BAh,04h,00h,080h,0BCh,04h,00h,00h,0BFh,04h,00h,080h,0C1h,04h,00h
        db 00h,0C4h,04h,00h,080h,0C6h,04h,00h,00h,0C9h,04h,00h,080h,0CBh,04h,00h
        db 00h,0CEh,04h,00h,080h,0D0h,04h,00h,00h,0D3h,04h,00h,080h,0D5h,04h,00h
        db 00h,0D8h,04h,00h,080h,0DAh,04h,00h,00h,0DDh,04h,00h,080h,0DFh,04h,00h
        db 00h,0E2h,04h,00h,080h,0E4h,04h,00h,00h,0E7h,04h,00h,080h,0E9h,04h,00h
        db 00h,0ECh,04h,00h,080h,0EEh,04h,00h,00h,0F1h,04h,00h,080h,0F3h,04h,00h
        db 00h,0F6h,04h,00h,080h,0F8h,04h,00h,00h,0FBh,04h,00h,080h,0FDh,04h,00h
        db 00h,00h,05h,00h,080h,02h,05h,00h,00h,05h,05h,00h,080h,07h,05h,00h
        db 00h,0Ah,05h,00h,080h,0Ch,05h,00h,00h,0Fh,05h,00h,080h,011h,05h,00h
        db 00h,014h,05h,00h,080h,016h,05h,00h,00h,019h,05h,00h,080h,01Bh,05h,00h
        db 00h,01Eh,05h,00h,080h,020h,05h,00h,00h,023h,05h,00h,080h,025h,05h,00h
        db 00h,028h,05h,00h,080h,02Ah,05h,00h,00h,02Dh,05h,00h,080h,02Fh,05h,00h
        db 00h,032h,05h,00h,080h,034h,05h,00h,00h,037h,05h,00h,080h,039h,05h,00h
        db 00h,03Ch,05h,00h,080h,03Eh,05h,00h,00h,041h,05h,00h,080h,043h,05h,00h
        db 00h,046h,05h,00h,080h,048h,05h,00h,00h,04Bh,05h,00h,080h,04Dh,05h,00h
        db 00h,050h,05h,00h,080h,052h,05h,00h,00h,055h,05h,00h,080h,057h,05h,00h
        db 00h,05Ah,05h,00h,080h,05Ch,05h,00h,00h,05Fh,05h,00h,080h,061h,05h,00h
        db 00h,064h,05h,00h,080h,066h,05h,00h,00h,069h,05h,00h,080h,06Bh,05h,00h
        db 00h,06Eh,05h,00h,080h,070h,05h,00h,00h,073h,05h,00h,080h,075h,05h,00h
        db 00h,078h,05h,00h,080h,07Ah,05h,00h,00h,07Dh,05h,00h,080h,07Fh,05h,00h
        db 00h,082h,05h,00h,080h,084h,05h,00h,00h,087h,05h,00h,080h,089h,05h,00h
        db 00h,08Ch,05h,00h,080h,08Eh,05h,00h,00h,091h,05h,00h,080h,093h,05h,00h
        db 00h,096h,05h,00h,080h,098h,05h,00h,00h,09Bh,05h,00h,080h,09Dh,05h,00h
        db 00h,0A0h,05h,00h,080h,0A2h,05h,00h,00h,0A5h,05h,00h,080h,0A7h,05h,00h
        db 00h,0AAh,05h,00h,080h,0ACh,05h,00h,00h,0AFh,05h,00h,080h,0B1h,05h,00h
        db 00h,0B4h,05h,00h,080h,0B6h,05h,00h,00h,0B9h,05h,00h,080h,0BBh,05h,00h
        db 00h,0BEh,05h,00h,080h,0C0h,05h,00h,00h,0C3h,05h,00h,080h,0C5h,05h,00h
        db 00h,0C8h,05h,00h,080h,0CAh,05h,00h,00h,0CDh,05h,00h,080h,0CFh,05h,00h
        db 00h,0D2h,05h,00h,080h,0D4h,05h,00h,00h,0D7h,05h,00h,080h,0D9h,05h,00h
        db 00h,0DCh,05h,00h,080h,0DEh,05h,00h,00h,0E1h,05h,00h,080h,0E3h,05h,00h
        db 00h,0E6h,05h,00h,080h,0E8h,05h,00h,00h,0EBh,05h,00h,080h,0EDh,05h,00h
        db 00h,0F0h,05h,00h,080h,0F2h,05h,00h,00h,0F5h,05h,00h,080h,0F7h,05h,00h
        db 00h,0FAh,05h,00h,080h,0FCh,05h,00h,00h,0FFh,05h,00h,080h,01h,06h,00h
        db 00h,04h,06h,00h,080h,06h,06h,00h,00h,09h,06h,00h,080h,0Bh,06h,00h
        db 00h,0Eh,06h,00h,080h,010h,06h,00h,00h,013h,06h,00h,080h,015h,06h,00h
        db 00h,018h,06h,00h,080h,01Ah,06h,00h,00h,01Dh,06h,00h,080h,01Fh,06h,00h
        db 00h,022h,06h,00h,080h,024h,06h,00h,00h,027h,06h,00h,080h,029h,06h,00h
        db 00h,02Ch,06h,00h,080h,02Eh,06h,00h,00h,031h,06h,00h,080h,033h,06h,00h
        db 00h,036h,06h,00h,080h,038h,06h,00h,00h,03Bh,06h,00h,080h,03Dh,06h,00h
        db 00h,040h,06h,00h,080h,042h,06h,00h,00h,045h,06h,00h,080h,047h,06h,00h
        db 00h,04Ah,06h,00h,080h,04Ch,06h,00h,00h,04Fh,06h,00h,080h,051h,06h,00h
        db 00h,054h,06h,00h,080h,056h,06h,00h,00h,059h,06h,00h,080h,05Bh,06h,00h
        db 00h,05Eh,06h,00h,080h,060h,06h,00h,00h,063h,06h,00h,080h,065h,06h,00h
        db 00h,068h,06h,00h,080h,06Ah,06h,00h,00h,06Dh,06h,00h,080h,06Fh,06h,00h
        db 00h,072h,06h,00h,080h,074h,06h,00h,00h,077h,06h,00h,080h,079h,06h,00h
        db 00h,07Ch,06h,00h,080h,07Eh,06h,00h,00h,081h,06h,00h,080h,083h,06h,00h
        db 00h,086h,06h,00h,080h,088h,06h,00h,00h,08Bh,06h,00h,080h,08Dh,06h,00h
        db 00h,090h,06h,00h,080h,092h,06h,00h,00h,095h,06h,00h,080h,097h,06h,00h
        db 00h,09Ah,06h,00h,080h,09Ch,06h,00h,00h,09Fh,06h,00h,080h,0A1h,06h,00h
        db 00h,0A4h,06h,00h,080h,0A6h,06h,00h,00h,0A9h,06h,00h,080h,0ABh,06h,00h
        db 00h,0AEh,06h,00h,080h,0B0h,06h,00h,00h,0B3h,06h,00h,080h,0B5h,06h,00h
        db 00h,0B8h,06h,00h,080h,0BAh,06h,00h,00h,0BDh,06h,00h,080h,0BFh,06h,00h
        db 00h,0C2h,06h,00h,080h,0C4h,06h,00h,00h,0C7h,06h,00h,080h,0C9h,06h,00h
        db 00h,0CCh,06h,00h,080h,0CEh,06h,00h,00h,0D1h,06h,00h,080h,0D3h,06h,00h
        db 00h,0D6h,06h,00h,080h,0D8h,06h,00h,00h,0DBh,06h,00h,080h,0DDh,06h,00h
        db 00h,0E0h,06h,00h,080h,0E2h,06h,00h,00h,0E5h,06h,00h,080h,0E7h,06h,00h
        db 00h,0EAh,06h,00h,080h,0ECh,06h,00h,00h,0EFh,06h,00h,080h,0F1h,06h,00h
        db 00h,0F4h,06h,00h,080h,0F6h,06h,00h,00h,0F9h,06h,00h,080h,0FBh,06h,00h
        db 00h,0FEh,06h,00h,080h,00h,07h,00h,00h,03h,07h,00h,080h,05h,07h,00h
        db 00h,08h,07h,00h,080h,0Ah,07h,00h,00h,0Dh,07h,00h,080h,0Fh,07h,00h
        db 00h,012h,07h,00h,080h,014h,07h,00h,00h,017h,07h,00h,080h,019h,07h,00h
        db 00h,01Ch,07h,00h,080h,01Eh,07h,00h,00h,021h,07h,00h,080h,023h,07h,00h
        db 00h,026h,07h,00h,080h,028h,07h,00h,00h,02Bh,07h,00h,080h,02Dh,07h,00h
        db 00h,030h,07h,00h,080h,032h,07h,00h,00h,035h,07h,00h,080h,037h,07h,00h
        db 00h,03Ah,07h,00h,080h,03Ch,07h,00h,00h,03Fh,07h,00h,080h,041h,07h,00h
        db 00h,044h,07h,00h,080h,046h,07h,00h,00h,049h,07h,00h,080h,04Bh,07h,00h
        db 00h,04Eh,07h,00h,080h,050h,07h,00h,00h,053h,07h,00h,080h,055h,07h,00h
        db 00h,058h,07h,00h,080h,05Ah,07h,00h,00h,05Dh,07h,00h,080h,05Fh,07h,00h
        db 00h,062h,07h,00h,080h,064h,07h,00h,00h,067h,07h,00h,080h,069h,07h,00h
        db 00h,06Ch,07h,00h,080h,06Eh,07h,00h,00h,071h,07h,00h,080h,073h,07h,00h
        db 00h,076h,07h,00h,080h,078h,07h,00h,00h,07Bh,07h,00h,080h,07Dh,07h,00h
        db 00h,080h,07h,00h,080h,082h,07h,00h,00h,085h,07h,00h,080h,087h,07h,00h
        db 00h,08Ah,07h,00h,080h,08Ch,07h,00h,00h,08Fh,07h,00h,080h,091h,07h,00h
        db 00h,094h,07h,00h,080h,096h,07h,00h,00h,099h,07h,00h,080h,09Bh,07h,00h
        db 00h,09Eh,07h,00h,080h,0A0h,07h,00h,00h,0A3h,07h,00h,080h,0A5h,07h,00h
        db 00h,0A8h,07h,00h,080h,0AAh,07h,00h,00h,0ADh,07h,00h,080h,0AFh,07h,00h
        db 00h,0B2h,07h,00h,080h,0B4h,07h,00h,00h,0B7h,07h,00h,080h,0B9h,07h,00h
        db 00h,0BCh,07h,00h,080h,0BEh,07h,00h,00h,0C1h,07h,00h,080h,0C3h,07h,00h
        db 00h,0C6h,07h,00h,080h,0C8h,07h,00h,00h,0CBh,07h,00h,080h,0CDh,07h,00h
        db 00h,0D0h,07h,00h,080h,0D2h,07h,00h,00h,0D5h,07h,00h,080h,0D7h,07h,00h
        db 00h,0DAh,07h,00h,080h,0DCh,07h,00h,00h,0DFh,07h,00h,080h,0E1h,07h,00h
        db 00h,0E4h,07h,00h,080h,0E6h,07h,00h,00h,0E9h,07h,00h,080h,0EBh,07h,00h
        db 00h,0EEh,07h,00h,080h,0F0h,07h,00h,00h,0F3h,07h,00h,080h,0F5h,07h,00h
        db 00h,0F8h,07h,00h,080h,0FAh,07h,00h,00h,0FDh,07h,00h,080h,0FFh,07h,00h
        db 00h,02h,08h,00h,080h,04h,08h,00h,00h,07h,08h,00h,080h,09h,08h,00h
        db 00h,0Ch,08h,00h,080h,0Eh,08h,00h,00h,011h,08h,00h,080h,013h,08h,00h
        db 00h,016h,08h,00h,080h,018h,08h,00h,00h,01Bh,08h,00h,080h,01Dh,08h,00h
        db 00h,020h,08h,00h,080h,022h,08h,00h,00h,025h,08h,00h,080h,027h,08h,00h
        db 00h,02Ah,08h,00h,080h,02Ch,08h,00h,00h,02Fh,08h,00h,080h,031h,08h,00h
        db 00h,034h,08h,00h,080h,036h,08h,00h,00h,039h,08h,00h,080h,03Bh,08h,00h
        db 00h,03Eh,08h,00h,080h,040h,08h,00h,00h,043h,08h,00h,080h,045h,08h,00h
        db 00h,048h,08h,00h,080h,04Ah,08h,00h,00h,04Dh,08h,00h,080h,04Fh,08h,00h
        db 00h,052h,08h,00h,080h,054h,08h,00h,00h,057h,08h,00h,080h,059h,08h,00h
        db 00h,05Ch,08h,00h,080h,05Eh,08h,00h,00h,061h,08h,00h,080h,063h,08h,00h
        db 00h,066h,08h,00h,080h,068h,08h,00h,00h,06Bh,08h,00h,080h,06Dh,08h,00h
        db 00h,070h,08h,00h,080h,072h,08h,00h,00h,075h,08h,00h,080h,077h,08h,00h
        db 00h,07Ah,08h,00h,080h,07Ch,08h,00h,00h,07Fh,08h,00h,080h,081h,08h,00h
        db 00h,084h,08h,00h,080h,086h,08h,00h,00h,089h,08h,00h,080h,08Bh,08h,00h
        db 00h,08Eh,08h,00h,080h,090h,08h,00h,00h,093h,08h,00h,080h,095h,08h,00h
        db 00h,098h,08h,00h,080h,09Ah,08h,00h,00h,09Dh,08h,00h,080h,09Fh,08h,00h
        db 00h,0A2h,08h,00h,080h,0A4h,08h,00h,00h,0A7h,08h,00h,080h,0A9h,08h,00h
        db 00h,0ACh,08h,00h,080h,0AEh,08h,00h,00h,0B1h,08h,00h,080h,0B3h,08h,00h
        db 00h,0B6h,08h,00h,080h,0B8h,08h,00h,00h,0BBh,08h,00h,080h,0BDh,08h,00h
        db 00h,0C0h,08h,00h,080h,0C2h,08h,00h,00h,0C5h,08h,00h,080h,0C7h,08h,00h
        db 00h,0CAh,08h,00h,080h,0CCh,08h,00h,00h,0CFh,08h,00h,080h,0D1h,08h,00h
        db 00h,0D4h,08h,00h,080h,0D6h,08h,00h,00h,0D9h,08h,00h,080h,0DBh,08h,00h
        db 00h,0DEh,08h,00h,080h,0E0h,08h,00h,00h,0E3h,08h,00h,080h,0E5h,08h,00h
        db 00h,0E8h,08h,00h,080h,0EAh,08h,00h,00h,0EDh,08h,00h,080h,0EFh,08h,00h
        db 00h,0F2h,08h,00h,080h,0F4h,08h,00h,00h,0F7h,08h,00h,080h,0F9h,08h,00h
        db 00h,0FCh,08h,00h,080h,0FEh,08h,00h,00h,01h,09h,00h,080h,03h,09h,00h
        db 00h,06h,09h,00h,080h,08h,09h,00h,00h,0Bh,09h,00h,080h,0Dh,09h,00h
        db 00h,010h,09h,00h,080h,012h,09h,00h,00h,015h,09h,00h,080h,017h,09h,00h
        db 00h,01Ah,09h,00h,080h,01Ch,09h,00h,00h,01Fh,09h,00h,080h,021h,09h,00h
        db 00h,024h,09h,00h,080h,026h,09h,00h,00h,029h,09h,00h,080h,02Bh,09h,00h
        db 00h,02Eh,09h,00h,080h,030h,09h,00h,00h,033h,09h,00h,080h,035h,09h,00h
        db 00h,038h,09h,00h,080h,03Ah,09h,00h,00h,03Dh,09h,00h,080h,03Fh,09h,00h
        db 00h,042h,09h,00h,080h,044h,09h,00h,00h,047h,09h,00h,080h,049h,09h,00h
        db 00h,04Ch,09h,00h,080h,04Eh,09h,00h,00h,051h,09h,00h,080h,053h,09h,00h
        db 00h,056h,09h,00h,080h,058h,09h,00h,00h,05Bh,09h,00h,080h,05Dh,09h,00h
        db 00h,060h,09h,00h,080h,062h,09h,00h,00h,065h,09h,00h,080h,067h,09h,00h
        db 00h,06Ah,09h,00h,080h,06Ch,09h,00h,00h,06Fh,09h,00h,080h,071h,09h,00h
        db 00h,074h,09h,00h,080h,076h,09h,00h,00h,079h,09h,00h,080h,07Bh,09h,00h
        db 00h,07Eh,09h,00h,080h,080h,09h,00h,00h,083h,09h,00h,080h,085h,09h,00h
        db 00h,088h,09h,00h,080h,08Ah,09h,00h,00h,08Dh,09h,00h,080h,08Fh,09h,00h
        db 00h,092h,09h,00h,080h,094h,09h,00h,00h,097h,09h,00h,080h,099h,09h,00h
        db 00h,09Ch,09h,00h,080h,09Eh,09h,00h,00h,0A1h,09h,00h,080h,0A3h,09h,00h
        db 00h,0A6h,09h,00h,080h,0A8h,09h,00h,00h,0ABh,09h,00h,080h,0ADh,09h,00h
        db 00h,0B0h,09h,00h,080h,0B2h,09h,00h,00h,0B5h,09h,00h,080h,0B7h,09h,00h
        db 00h,0BAh,09h,00h,080h,0BCh,09h,00h,00h,0BFh,09h,00h,080h,0C1h,09h,00h
        db 00h,0C4h,09h,00h,080h,0C6h,09h,00h,00h,0C9h,09h,00h,080h,0CBh,09h,00h
        db 00h,0CEh,09h,00h,080h,0D0h,09h,00h,00h,0D3h,09h,00h,080h,0D5h,09h,00h
        db 00h,0D8h,09h,00h,080h,0DAh,09h,00h,00h,0DDh,09h,00h,080h,0DFh,09h,00h
        db 00h,0E2h,09h,00h,080h,0E4h,09h,00h,00h,0E7h,09h,00h,080h,0E9h,09h,00h
        db 00h,0ECh,09h,00h,080h,0EEh,09h,00h,00h,0F1h,09h,00h,080h,0F3h,09h,00h
        db 00h,0F6h,09h,00h,080h,0F8h,09h,00h,00h,0FBh,09h,00h,080h,0FDh,09h,00h
        db 00h,00h,0Ah,00h
PutBlockScaleSteps:                             ; Block scale steps; used by FillRect, PutBlock, initgraphics
        db 066h,00h,00h,00h,0CCh,00h,00h,00h,033h,01h,00h,00h,099h,01h,00h,00h
        db 00h,02h,00h,00h,00h,04h,00h,00h,00h,04h,00h,00h,00h,04h,00h,00h
        db 00h,04h,00h,00h,00h,04h,00h,00h,00h,04h,00h,00h,00h,04h,00h,00h
        db 00h,04h,00h,00h,00h,04h,00h,00h,00h,04h,00h,00h,00h,04h,00h,00h
        db 00h,04h,00h,00h,00h,04h,00h,00h,00h,04h,00h,00h,00h,04h,00h,00h
JoyRawX1:                                       ; Timed count for joystick 1 X; used by CalibrateJoystick,
                                                ; main_
        db 00h,00h,00h,00h
JoyRawY1:                                       ; Timed count for joystick 1 Y; used by CalibrateJoystick,
                                                ; main_
        db 00h,00h,00h,00h
JoyRawX2:                                       ; Timed count for joystick 2 X; used by CalibrateJoystick,
                                                ; main_
        db 00h,00h,00h,00h
JoyRawY2:                                       ; Timed count for joystick 2 Y; used by CalibrateJoystick,
                                                ; main_
        db 00h,00h,00h,00h
JoyButtonBits:                                  ; Joystick button bits from the last read; used by
                                                ; CalibrateJoystick
        db 00h,00h
JoyPortMask:                                    ; Axis bits still present on port 201h; used by
                                                ; CalibrateJoystick, PollJoystickEvent, main_
        db 0Fh,00h
JoyAxisY2:                                      ; used by JoyScaledX, ReadJoystickPorts
        db 00h,00h,00h,00h
JoyAxisMask:                                    ; used by JoyScaledX, ReadJoystickPorts
        db 00h,00h,00h,00h
JoyButtons:                                     ; Last joystick button byte; used by ReadJoystickPorts
        db 00h
JoyButtonsPrev:                                 ; Previous joystick button byte; used by ReadJoystickPorts
        db 00h
JoyDirection:                                   ; Joystick direction bits built from the axes; used by
                                                ; ReadJoystickPorts
        db 00h
JoyX1Threshold:                                 ; used by JoyResetCentres, JoyScaledX, ReadJoystickPorts
        db 050h,00h,00h,00h
JoyX1Min:                                       ; Joystick 1 X axis minimum seen; used by ReadJoystickPorts
        db 00h,00h,00h,00h
JoyX1Center:                                    ; used by JoyResetCentres, ReadJoystickPorts
        db 00h,00h,00h,00h
JoyX1Max:                                       ; Joystick 1 X axis maximum seen; used by ReadJoystickPorts
        db 00h,00h,00h,00h
JoyX1Settle:                                    ; Reads left before the joystick 1 X range is trusted; used by
                                                ; ReadJoystickPorts
        db 014h,00h,00h,00h
JoyY1Min:                                       ; Joystick 1 Y axis minimum seen; used by ReadJoystickPorts
        db 00h,00h,00h,00h
JoyY1Max:                                       ; Joystick 1 Y axis maximum seen; used by ReadJoystickPorts
        db 00h,00h,00h,00h
JoyY1Threshold:                                 ; used by JoyResetCentres, JoyScaledX, ReadJoystickPorts
        db 050h,00h,00h,00h
JoyY1MinSeen:                                   ; Joystick 1 Y axis lowest reading this pass; used by
                                                ; ReadJoystickPorts
        db 00h,00h,00h,00h
JoyY1Center:                                    ; used by JoyResetCentres, ReadJoystickPorts
        db 00h,00h,00h,00h
JoyY1MaxSeen:                                   ; Joystick 1 Y axis highest reading this pass; used by
                                                ; ReadJoystickPorts
        db 00h,00h,00h,00h
JoyY1Settle:                                    ; Reads left before the joystick 1 Y range is trusted; used by
                                                ; ReadJoystickPorts
        db 014h,00h,00h,00h
JoyX2Min:                                       ; Joystick 2 X axis minimum seen; used by ReadJoystickPorts
        db 00h,00h,00h,00h
JoyX2Max:                                       ; Joystick 2 X axis maximum seen; used by ReadJoystickPorts
        db 00h,00h,00h,00h
JoyXScale:                                      ; used by JoyScaledX, ReadJoystickPorts
        db 00h,00h,00h,00h
JoyYScale:                                      ; used by JoyScaledX, ReadJoystickPorts
        db 00h,00h,00h,00h
joyedgedir:                                     ; joystick library table: direction for each edge mask (1 up,
                                                ; 2 down, 4 right, 8 left); used by JoyButtonMap
        db 00h,01h,05h,00h,03h,02h,04h,03h,07h,08h,06h,07h,00h,01h,05h,00h
        db 00h
randseed:                                       ; used by GetRandState
        db 01h,00h,00h,00h
SndInitDone:                                    ; Set once the sound system has been set up; used by SndInit
        db 00h
SndBigEndian:                                   ; Byte order flag for timbre and patch data; used by
                                                ; LinkPatchTimbres, LoadTimbreFile, SetSoundByteOrder
        db 00h
SampleChunkSize:                                ; Chunk size used when loading samples; used by LoadSample
        db 00h,02h,00h,00h
DefaultSampleInfo:                              ; Default six-dword sample description copied by LoadSample;
                                                ; used by LoadSample
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0C8h,00h,00h,00h
        db 00h,07Fh,03Fh,00h,00h,00h,00h,00h
PlayPatchHandle:                                ; Handle of the last patch played; used by PlayPatch
        db 00h,00h,00h,00h,00h,00h
bailout_vec:                                    ; called on the debug 'bail' key in DebugMonitor, from
                                                ; main_startup and from the keyboard handler; exit/abort
                                                ; vector; used by AskExitToDos, DebugMonitor, DeskExitGame ...
        dd ExitProgram
FpuFlags:                                       ; used by InitFpuFlags, __saved_DS, __sys_fini_387_emulator
        db 00h,00h,00h,00h
EmuHookFlags:                                   ; used by InitFpuFlags, __saved_DS, __sys_fini_387_emulator
        db 020h,00h
SavedEsSelector:                                ; ES selector saved at start up; used by InitFpuFlags
        db 00h,00h
Joy2RawX:                                       ; Joystick 2 raw X; used by Joy2ScaledX, ReadJoyRaw
        db 00h,00h,00h,00h
Joy2RawY:                                       ; Joystick 2 raw Y; used by Joy2ScaledX, ReadJoyRaw
        db 00h,00h,00h,00h
Joy2XMin:                                       ; Joystick 2 X minimum; used by Joy2ScaledX, JoyDefaultCalib2,
                                                ; ReadJoyRaw
        db 050h,00h,00h,00h
Joy2XMax:                                       ; Joystick 2 X maximum; used by JoyDefaultCalib2, ReadJoyRaw
        db 00h,00h,00h,00h
Joy2XCenter:                                    ; Joystick 2 X centre; used by ReadJoyRaw
        db 00h,00h,00h,00h
Joy2XSettle:                                    ; Joystick 2 X settle countdown; used by ReadJoyRaw
        db 00h,00h,00h,00h
Joy2XMinSeen:                                   ; Lowest joystick 2 X seen; used by ReadJoyRaw
        db 00h,00h,00h,00h
Joy2XMaxSeen:                                   ; Highest joystick 2 X seen; used by ReadJoyRaw
        db 00h,00h,00h,00h
Joy2YMin:                                       ; Joystick 2 Y minimum; used by Joy2ScaledX, JoyDefaultCalib2,
                                                ; ReadJoyRaw
        db 050h,00h,00h,00h
Joy2YMax:                                       ; Joystick 2 Y maximum; used by JoyDefaultCalib2, ReadJoyRaw
        db 00h,00h,00h,00h
Joy2YCenter:                                    ; Joystick 2 Y centre; used by ReadJoyRaw
        db 00h,00h,00h,00h
Joy2YSettle:                                    ; Joystick 2 Y settle countdown; used by ReadJoyRaw
        db 00h,00h,00h,00h
Joy2YMinSeen:                                   ; Lowest joystick 2 Y seen; used by ReadJoyRaw
        db 00h,00h,00h,00h
Joy2YMaxSeen:                                   ; Highest joystick 2 Y seen; used by ReadJoyRaw
        db 00h,00h,00h,00h
Joy2XScale:                                     ; Joystick 2 X scale factor; used by Joy2ScaledX, ReadJoyRaw
        db 00h,00h,00h,00h
Joy2YScale:                                     ; Joystick 2 Y scale factor; used by Joy2ScaledX, ReadJoyRaw
        db 00h,00h,00h,00h
Joy1RawX:                                       ; Joystick 1 raw X; used by Joy2ScaledX, ReadJoyRaw
        db 00h,00h,00h,00h
Joy1RawY:                                       ; Joystick 1 raw Y; used by Joy2ScaledX, ReadJoyRaw
        db 00h,00h,00h,00h
JoyRawButtons:                                  ; Button bits from the raw joystick read; used by ReadJoyRaw
        db 00h
Joy1RawDirection:                               ; Direction bits for joystick 1 from the raw read; used by
                                                ; ReadJoyRaw
        db 00h
Joy2RawDirection:                               ; Direction bits for joystick 2 from the raw read; used by
                                                ; ReadJoyRaw
        db 00h,00h
Joy1XMin:                                       ; Joystick 1 X minimum; used by Joy2ScaledX, JoyDefaultCalib1,
                                                ; ReadJoyRaw
        db 050h,00h,00h,00h
Joy1XMax:                                       ; Joystick 1 X maximum; used by JoyDefaultCalib1, ReadJoyRaw
        db 00h,00h,00h,00h
Joy1XCenter:                                    ; Joystick 1 X centre; used by ReadJoyRaw
        db 00h,00h,00h,00h
Joy1XSettle:                                    ; Joystick 1 X settle countdown; used by ReadJoyRaw
        db 00h,00h,00h,00h
Joy1XMinSeen:                                   ; Lowest joystick 1 X seen; used by ReadJoyRaw
        db 00h,00h,00h,00h
Joy1XMaxSeen:                                   ; Highest joystick 1 X seen; used by ReadJoyRaw
        db 00h,00h,00h,00h
Joy1YMin:                                       ; Joystick 1 Y minimum; used by Joy2ScaledX, JoyDefaultCalib1,
                                                ; ReadJoyRaw
        db 050h,00h,00h,00h
Joy1YMax:                                       ; Joystick 1 Y maximum; used by JoyDefaultCalib1, ReadJoyRaw
        db 00h,00h,00h,00h
Joy1YCenter:                                    ; Joystick 1 Y centre; used by ReadJoyRaw
        db 00h,00h,00h,00h
Joy1YSettle:                                    ; Joystick 1 Y settle countdown; used by ReadJoyRaw
        db 00h,00h,00h,00h
Joy1YMinSeen:                                   ; Lowest joystick 1 Y seen; used by ReadJoyRaw
        db 00h,00h,00h,00h
Joy1YMaxSeen:                                   ; Highest joystick 1 Y seen; used by ReadJoyRaw
        db 00h,00h,00h,00h
Joy1XScale:                                     ; Joystick 1 X scale factor; used by Joy2ScaledX, ReadJoyRaw
        db 00h,00h,00h,00h
Joy1YScale:                                     ; Joystick 1 Y scale factor; used by Joy2ScaledX, ReadJoyRaw
        db 00h,00h,00h,00h
JoyDirLookup:                                   ; Direction bits to direction code table; used by ReadJoyRaw
        db 00h,03h,0Ch,0Fh,00h,01h,05h,00h,03h,02h,04h,03h,07h,08h,06h,07h
        db 00h,01h,05h,00h
tickdeadline:                                   ; SetTickDeadline writes tickcount + n; WaitTickDeadline and
                                                ; TickDeadlinePassed compare tickcount with it; used by
                                                ; SetTickDeadline, TickDeadlinePassed, WaitTickDeadline
        db 00h,00h,00h,00h
ticklast:                                       ; TicksSinceLastCall: tickcount at the previous call; used by
                                                ; TicksSinceLastCall
        db 00h,00h,00h,00h
RetraceTimeout:                                 ; Loop count before giving up on vertical retrace; used by
                                                ; ResetRetraceTimeout, WaitRetrace, WaitRetraceEnd ...
        db 0A0h,086h,01h,00h
KbdIdleHook:                                    ; used by KbdIdleWait, KbdPeekKey, PollKey ...
        dd PollHotkeys
TextFont:                                       ; Current text font; used by PrintStringAtCursor, TextPrint,
                                                ; TextRestoreState ...
        dd DefaultFont
fontcolor:                                      ; current font colour read by the text blitter (PrintString);
                                                ; the Print* routines set it from textshadow / textcolor; used
                                                ; by DrawCalendarDay, DrawEditCursor, HilightSaveToDlg ...
        db 0Fh,00h,00h,00h
TextBackColor:                                  ; Text background colour; used by DrawEditText, InputDialog,
                                                ; TextPrint ...
        db 00h,00h,00h,00h
TextOriginX:                                    ; X of the text drawing position; used by PrintStringAtCursor,
                                                ; TextPrint, TextSetCursor
        db 00h,00h,00h,00h
TextOriginY:                                    ; Text origin Y; used by PrintStringAtCursor, TextPrint,
                                                ; TextSetCursor
        db 00h,00h,00h,00h
TextShadowOn:                                   ; Text shadow is on; used by TextSetFont
        db 00h,00h,00h,00h
TextFontTag:                                    ; Text font tag; used by PrintStringAtCursor, TextPrint,
                                                ; TextSetFont
        db 031h,044h,033h,046h
TextFirstChar:                                  ; First character in the font; used by PrintStringAtCursor,
                                                ; TextPrint, TextSetFont ...
        db 020h
TextLastChar:                                   ; Last character in the font; used by PrintStringAtCursor,
                                                ; TextPrint, TextSetFont ...
        db 08Eh
TextCharW:                                      ; Font character width; used by PrintStringAtCursor,
                                                ; TextPrint, TextSetFont ...
        db 08h
TextCharH:                                      ; Font character height; used by DrawButton, DrawListItem,
                                                ; DrawRosterList ...
        db 08h
TextSpacing:                                    ; Font spacing; used by PrintStringAtCursor, TextPrint,
                                                ; TextSetFont ...
        db 00h
TextFontH:                                      ; Font height; used by DrawEditCursor, DrawEditText,
                                                ; TextSetFont
        db 08h
TextFontAscent:                                 ; Font ascent of the current font; used by TextSetFont
        db 07h,00h
TextWidthTable:                                 ; Font width table; used by PrintStringAtCursor, TextPrint,
                                                ; TextSetFont ...
        dd DefaultFontWidths
TextCursorX:                                    ; Text cursor x; used by PrintStringAtCursor, TextPrint,
                                                ; TextSetFont
        db 00h,00h,00h,00h
TextCursorY:                                    ; Text cursor y; used by PrintStringAtCursor, TextPrint,
                                                ; TextSetFont ...
        db 00h,00h,00h,00h
TextLeft:                                       ; Left edge of the text window; used by PrintStringAtCursor,
                                                ; TextPrint, TextSetFont
        db 00h,00h,00h,00h
TextTop:                                        ; Text window top; used by PrintStringAtCursor, TextPrint,
                                                ; TextSetFont
        db 00h,00h,00h,00h
TextRight:                                      ; Text window right; used by PrintStringAtCursor, TextPrint,
                                                ; TextSetFont
        db 00h,00h,00h,00h
TextBottom:                                     ; Carried name by usage; used by PrintStringAtCursor,
                                                ; TextPrint, TextSetFont
        dd DefaultFontOffsets
ColourRemap:                                    ; 256-entry colour remap table; used by BlitArtKeyColour,
                                                ; BlitArtMasked, CopyRowRemapKeyed ...
        db 00h,01h,02h,03h,04h,05h,06h,07h,08h,09h,0Ah,0Bh,0Ch,0Dh,0Eh,0Fh
        db 010h,011h,012h,013h,014h,015h,016h,017h,018h,019h,01Ah,01Bh,01Ch,01Dh,01Eh,01Fh
        db 020h,021h,022h,023h,024h,025h,026h,027h,028h,029h,02Ah,02Bh,02Ch,02Dh,02Eh,02Fh
        db 030h,031h,032h,033h,034h,035h,036h,037h,038h,039h,03Ah,03Bh,03Ch,03Dh,03Eh,03Fh
        db 040h,041h,042h,043h,044h,045h,046h,047h,048h,049h,04Ah,04Bh,04Ch,04Dh,04Eh,04Fh
        db 050h,051h,052h,053h,054h,055h,056h,057h,058h,059h,05Ah,05Bh,05Ch,05Dh,05Eh,05Fh
        db 060h,061h,062h,063h,064h,065h,066h,067h,068h,069h,06Ah,06Bh,06Ch,06Dh,06Eh,06Fh
        db 070h,071h,072h,073h,074h,075h,076h,077h,078h,079h,07Ah,07Bh,07Ch,07Dh,07Eh,07Fh
        db 080h,081h,082h,083h,084h,085h,086h,087h,088h,089h,08Ah,08Bh,08Ch,08Dh,08Eh,08Fh
        db 090h,091h,092h,093h,094h,095h,096h,097h,098h,099h,09Ah,09Bh,09Ch,09Dh,09Eh,09Fh
        db 0A0h,0A1h,0A2h,0A3h,0A4h,0A5h,0A6h,0A7h,0A8h,0A9h,0AAh,0ABh,0ACh,0ADh,0AEh,0AFh
        db 0B0h,0B1h,0B2h,0B3h,0B4h,0B5h,0B6h,0B7h,0B8h,0B9h,0BAh,0BBh,0BCh,0BDh,0BEh,0BFh
        db 0C0h,0C1h,0C2h,0C3h,0C4h,0C5h,0C6h,0C7h,0C8h,0C9h,0CAh,0CBh,0CCh,0CDh,0CEh,0CFh
        db 0D0h,0D1h,0D2h,0D3h,0D4h,0D5h,0D6h,0D7h,0D8h,0D9h,0DAh,0DBh,0DCh,0DDh,0DEh,0DFh
        db 0E0h,0E1h,0E2h,0E3h,0E4h,0E5h,0E6h,0E7h,0E8h,0E9h,0EAh,0EBh,0ECh,0EDh,0EEh,0EFh
        db 0F0h,0F1h,0F2h,0F3h,0F4h,0F5h,0F6h,0F7h,0F8h,0F9h,0FAh,0FBh,0FCh,0FDh,0FEh,0FFh
RowCopyFunc:                                    ; used by DrawArt, DrawArtKeyColour, DrawArtKeyFF ...
        dd bcopy
HeapList:                                       ; used by __ExpandDGROUP_, __FreeDPMIBlocks_,
                                                ; __HeapManager_expand_ ...
        db 00h,00h,00h,00h
HeapRover:                                      ; used by __unlink_, _nfree_, _nmalloc_
        db 00h,00h,00h,00h
HeapLargestFree:                                ; used by _nfree_, _nmalloc_
        db 00h,00h,00h,00h
str_OpenhandleSFILEERROR:                       ; "openhandle - %s FILE ERROR\r" string literal; used by
                                                ; openhandle
        db 06Fh,070h,065h,06Eh,068h,061h,06Eh,064h,06Ch,065h,020h,02Dh,020h,025h,073h,020h
        db 046h,049h,04Ch,045h,020h,045h,052h,052h,04Fh,052h,0Dh,00h
ResourceArchiveName:                            ; used by openhandle
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h
ArchiveHandle:                                  ; used by openhandle
        db 00h,00h,00h,00h
ArchiveOpenFn:                                  ; used by openhandle
        db 00h,00h,00h,00h
ArchiveCount:                                   ; used by openhandle
        db 00h,00h,00h,00h
ResourceArchive:                                ; used by openhandle
        db 00h,00h,00h,00h
FindFileDta:                                    ; Find file data block; used by FindFirstFile
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h
FindFilePtr:                                    ; Find file pointer; used by FindFirstFile
        db 00h,00h,00h,00h
FindFileName:                                   ; Find file name; used by FindFirstFile, FindNextFile
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
FindFilePattern:                                ; Find file pattern; used by FindFirstFile
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h
SlowDeadline:                                   ; Slow-tick deadline; used by SetSlowDeadline,
                                                ; SlowDeadlinePassed, WaitSlowDeadline
        db 00h,00h,00h,00h
DebugMode:                                      ; used by DebugClearScreen, DebugLog, DebugLogPrintf ...
        db 02h,00h,00h,00h,00h,00h,00h,00h
DebugScreenBase:                                ; used by DebugClearScreen, DebugScrollUp, DebugSetPage ...
        db 00h,00h,0Bh,00h
DebugLineWidth:                                 ; used by DebugScrollUp, DebugSetLine, DebugShowLines
        db 080h,07h,00h,00h
DebugRow:                                       ; used by DebugScrollUp, DebugSetRow, DebugShowLines ...
        db 00h
DebugBackColor:                                 ; Debug background colour; used by DebugSetAttr,
                                                ; DebugShowLines
        db 07h
DebugTabWidth:                                  ; Debug monitor tab width; used by DebugSetTabWidth,
                                                ; DebugShowLines
        db 08h,02Fh
DebugLogOn:                                     ; used by DebugLog, DebugLogClose, DebugLogOpen ...
        db 00h,00h,00h,00h
        dd str_Jan
        dd str_Feb2
        dd str_Mar
        dd str_Apr
        dd str_May2
        dd str_Jun
        dd str_Jul
        dd str_Aug
        dd str_Sep
        dd str_Oct
        dd str_Nov
        dd str_Dec
MemViewBlack:                                   ; used by MemViewer, MemViewerBlockInfo, MemViewerDrawList ...
        db 00h,00h,00h,00h
MemViewWhite:                                   ; used by MemViewer, MemViewerBlockInfo, MemViewerSelectRow
                                                ; ...
        db 03h,00h,00h,00h
MemViewYellow:                                  ; used by MemViewer, MemViewerBlockInfo, MemViewerDrawList ...
        db 03h,00h,00h,00h
MemViewGreen:                                   ; used by MemViewer, MemViewerDrawList
        db 01h,00h,00h,00h
MemViewRed:                                     ; used by MemViewer, MemViewerBlockInfo, MemViewerDrawList
        db 02h,00h,00h,00h
MemViewShowDetail:                              ; used by MemViewerDrawList, MemViewerDrawRows, WriteMemMap
        db 00h,00h,00h,00h
MemViewOpen:                                    ; Non-zero while the memory viewer is open; used by MemViewer,
                                                ; MemViewerGetMode, MemViewerStart
        db 00h,00h,00h,00h
MemViewCursor:                                  ; Memory viewer cursor; used by MemViewerDrawTitle,
                                                ; MemViewerListHead
        db 00h,00h,00h,00h
MemViewRowY:                                    ; Screen Y of the memory viewer row being drawn; used by
                                                ; MemViewer, MemViewerDrawRows
        db 00h,00h,00h,00h
MemViewRowX:                                    ; Screen X of the memory viewer row being drawn; used by
                                                ; MemViewer, MemViewerDrawRows
        db 00h,00h,00h,00h
PaletteCursorColours:                           ; Palette viewer cursor xor colours; used by PaletteViewer
        db 0FFh,0FFh,00h,00h,0AAh,0AAh,00h,00h,055h,055h,00h,00h
DebugLastKey:                                   ; Last key read by the debug key reader; used by
                                                ; DebugGetKeyUpper
        db 00h,00h,00h,00h
joycalprehook:                                  ; called before calibration; used by JoystickCalScreen,
                                                ; ShowPromptBox
        dd ReturnZero
joycalposthook:                                 ; called after calibration; used by JoystickCalScreen,
                                                ; ShowPromptBox
        dd ReturnZero
        dd ReturnZero
        dd ReturnZero
        dd ReturnZero
        dd ReturnZero
        dd ReturnZero
        dd ReturnZero
        db 00h,00h,00h,00h
DefaultFont:                                    ; used by JoystickCalScreen, MemViewer, ShowMessageBox ...
        db 046h,050h,043h,031h,020h,08Eh,08h,08h,00h,08h,06h,01h,00h,00h,00h,0FFh
        db 00h,00h,0DCh,01h,00h,00h,00h,00h,00h,00h,00h,00h,053h,048h,041h,057h
DefaultFontOffsets:                             ; Character offset table of the built-in font
        db 04Bh,02h,00h,00h,053h,02h,00h,00h,05Bh,02h,00h,00h,063h,02h,00h,00h
        db 06Bh,02h,00h,00h,073h,02h,00h,00h,07Bh,02h,00h,00h,083h,02h,00h,00h
        db 08Bh,02h,00h,00h,093h,02h,00h,00h,09Bh,02h,00h,00h,0A3h,02h,00h,00h
        db 0ABh,02h,00h,00h,0B3h,02h,00h,00h,0BBh,02h,00h,00h,0C3h,02h,00h,00h
        db 0CBh,02h,00h,00h,0D3h,02h,00h,00h,0DBh,02h,00h,00h,0E3h,02h,00h,00h
        db 0EBh,02h,00h,00h,0F3h,02h,00h,00h,0FBh,02h,00h,00h,03h,03h,00h,00h
        db 0Bh,03h,00h,00h,013h,03h,00h,00h,01Bh,03h,00h,00h,023h,03h,00h,00h
        db 02Bh,03h,00h,00h,033h,03h,00h,00h,03Bh,03h,00h,00h,043h,03h,00h,00h
        db 04Bh,03h,00h,00h,053h,03h,00h,00h,05Bh,03h,00h,00h,063h,03h,00h,00h
        db 06Bh,03h,00h,00h,073h,03h,00h,00h,07Bh,03h,00h,00h,083h,03h,00h,00h
        db 08Bh,03h,00h,00h,093h,03h,00h,00h,09Bh,03h,00h,00h,0A3h,03h,00h,00h
        db 0ABh,03h,00h,00h,0B3h,03h,00h,00h,0BBh,03h,00h,00h,0C3h,03h,00h,00h
        db 0CBh,03h,00h,00h,0D3h,03h,00h,00h,0DBh,03h,00h,00h,0E3h,03h,00h,00h
        db 0EBh,03h,00h,00h,0F3h,03h,00h,00h,0FBh,03h,00h,00h,03h,04h,00h,00h
        db 0Bh,04h,00h,00h,013h,04h,00h,00h,01Bh,04h,00h,00h,023h,04h,00h,00h
        db 02Bh,04h,00h,00h,033h,04h,00h,00h,03Bh,04h,00h,00h,043h,04h,00h,00h
        db 04Bh,04h,00h,00h,053h,04h,00h,00h,05Bh,04h,00h,00h,063h,04h,00h,00h
        db 06Bh,04h,00h,00h,073h,04h,00h,00h,07Bh,04h,00h,00h,083h,04h,00h,00h
        db 08Bh,04h,00h,00h,093h,04h,00h,00h,09Bh,04h,00h,00h,0A3h,04h,00h,00h
        db 0ABh,04h,00h,00h,0B3h,04h,00h,00h,0BBh,04h,00h,00h,0C3h,04h,00h,00h
        db 0CBh,04h,00h,00h,0D3h,04h,00h,00h,0DBh,04h,00h,00h,0E3h,04h,00h,00h
        db 0EBh,04h,00h,00h,0F3h,04h,00h,00h,0FBh,04h,00h,00h,03h,05h,00h,00h
        db 0Bh,05h,00h,00h,013h,05h,00h,00h,01Bh,05h,00h,00h,023h,05h,00h,00h
        db 02Bh,05h,00h,00h,033h,05h,00h,00h,03Bh,05h,00h,00h,043h,05h,00h,00h
        db 04Bh,05h,00h,00h,053h,05h,00h,00h,05Bh,05h,00h,00h,063h,05h,00h,00h
        db 06Bh,05h,00h,00h,073h,05h,00h,00h,07Bh,05h,00h,00h,083h,05h,00h,00h
        db 08Bh,05h,00h,00h,093h,05h,00h,00h,09Bh,05h,00h,00h,0A3h,05h,00h,00h
        db 0ABh,05h,00h,00h,0B3h,05h,00h,00h,0BBh,05h,00h,00h
DefaultFontWidths:                              ; Character width table of the built-in font
        db 08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h
        db 08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h
        db 08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h
        db 08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h
        db 08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h
        db 08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h
        db 08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,00h
        db 00h,00h,00h,00h,00h,00h,00h,030h,078h,078h,030h,030h,00h,030h,00h,06Ch
        db 06Ch,06Ch,00h,00h,00h,00h,00h,06Ch,06Ch,0FEh,06Ch,0FEh,06Ch,06Ch,00h,030h
        db 07Ch,0C0h,078h,0Ch,0F8h,030h,00h,00h,0C6h,0CCh,018h,030h,066h,0C6h,00h,038h
        db 06Ch,038h,076h,0DCh,0CCh,076h,00h,060h,060h,0C0h,00h,00h,00h,00h,00h,018h
        db 030h,060h,060h,060h,030h,018h,00h,060h,030h,018h,018h,018h,030h,060h,00h,00h
        db 066h,03Ch,0FFh,03Ch,066h,00h,00h,00h,030h,030h,0FCh,030h,030h,00h,00h,00h
        db 00h,00h,00h,00h,030h,030h,060h,00h,00h,00h,0FCh,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,030h,030h,00h,06h,0Ch,018h,030h,060h,0C0h,080h,00h,07Ch
        db 0C6h,0C6h,0C6h,0C6h,0C6h,07Ch,00h,030h,070h,030h,030h,030h,030h,0FCh,00h,078h
        db 0CCh,0Ch,038h,060h,0CCh,0FCh,00h,078h,0CCh,0Ch,038h,0Ch,0CCh,078h,00h,01Ch
        db 03Ch,06Ch,0CCh,0FEh,0Ch,01Eh,00h,0FCh,0C0h,0F8h,0Ch,0Ch,0CCh,078h,00h,038h
        db 060h,0C0h,0F8h,0CCh,0CCh,078h,00h,0FCh,0CCh,0Ch,018h,030h,030h,030h,00h,078h
        db 0CCh,0CCh,078h,0CCh,0CCh,078h,00h,078h,0CCh,0CCh,07Ch,0Ch,018h,070h,00h,00h
        db 030h,030h,00h,00h,030h,030h,00h,00h,030h,030h,00h,00h,030h,030h,060h,018h
        db 030h,060h,0C0h,060h,030h,018h,00h,00h,00h,0FCh,00h,00h,0FCh,00h,00h,060h
        db 030h,018h,0Ch,018h,030h,060h,00h,078h,0CCh,0Ch,018h,030h,00h,030h,00h,07Ch
        db 0C6h,0DEh,0DEh,0DEh,0C0h,078h,00h,030h,078h,0CCh,0CCh,0FCh,0CCh,0CCh,00h,0FCh
        db 066h,066h,07Ch,066h,066h,0FCh,00h,03Ch,066h,0C0h,0C0h,0C0h,066h,03Ch,00h,0F8h
        db 06Ch,066h,066h,066h,06Ch,0F8h,00h,0FEh,062h,068h,078h,068h,062h,0FEh,00h,0FEh
        db 062h,068h,078h,068h,060h,0F0h,00h,03Ch,066h,0C0h,0C0h,0CEh,066h,03Eh,00h,0CCh
        db 0CCh,0CCh,0FCh,0CCh,0CCh,0CCh,00h,078h,030h,030h,030h,030h,030h,078h,00h,01Eh
        db 0Ch,0Ch,0Ch,0CCh,0CCh,078h,00h,0E6h,066h,06Ch,078h,06Ch,066h,0E6h,00h,0F0h
        db 060h,060h,060h,062h,066h,0FEh,00h,0C6h,0EEh,0FEh,0FEh,0D6h,0C6h,0C6h,00h,0C6h
        db 0E6h,0F6h,0DEh,0CEh,0C6h,0C6h,00h,038h,06Ch,0C6h,0C6h,0C6h,06Ch,038h,00h,0FCh
        db 066h,066h,07Ch,060h,060h,0F0h,00h,078h,0CCh,0CCh,0CCh,0DCh,078h,01Ch,00h,0FCh
        db 066h,066h,07Ch,06Ch,066h,0E6h,00h,078h,0CCh,0E0h,070h,01Ch,0CCh,078h,00h,0FCh
        db 0B4h,030h,030h,030h,030h,078h,00h,0CCh,0CCh,0CCh,0CCh,0CCh,0CCh,0FCh,00h,0CCh
        db 0CCh,0CCh,0CCh,0CCh,078h,030h,00h,0C6h,0C6h,0C6h,0D6h,0FEh,0EEh,0C6h,00h,0C6h
        db 0C6h,06Ch,038h,038h,06Ch,0C6h,00h,0CCh,0CCh,0CCh,078h,030h,030h,078h,00h,0FEh
        db 0C6h,08Ch,018h,032h,066h,0FEh,00h,078h,060h,060h,060h,060h,060h,078h,00h,0C0h
        db 060h,030h,018h,0Ch,06h,02h,00h,078h,018h,018h,018h,018h,018h,078h,00h,010h
        db 038h,06Ch,0C6h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0FFh,030h
        db 030h,018h,00h,00h,00h,00h,00h,00h,00h,078h,0Ch,07Ch,0CCh,076h,00h,0E0h
        db 060h,060h,07Ch,066h,066h,0DCh,00h,00h,00h,078h,0CCh,0C0h,0CCh,078h,00h,01Ch
        db 0Ch,0Ch,07Ch,0CCh,0CCh,076h,00h,00h,00h,078h,0CCh,0FCh,0C0h,078h,00h,038h
        db 06Ch,060h,0F0h,060h,060h,0F0h,00h,00h,00h,076h,0CCh,0CCh,07Ch,0Ch,0F8h,0E0h
        db 060h,06Ch,076h,066h,066h,0E6h,00h,030h,00h,070h,030h,030h,030h,078h,00h,0Ch
        db 00h,0Ch,0Ch,0Ch,0CCh,0CCh,078h,0E0h,060h,066h,06Ch,078h,06Ch,0E6h,00h,070h
        db 030h,030h,030h,030h,030h,078h,00h,00h,00h,0CCh,0FEh,0FEh,0D6h,0C6h,00h,00h
        db 00h,0F8h,0CCh,0CCh,0CCh,0CCh,00h,00h,00h,078h,0CCh,0CCh,0CCh,078h,00h,00h
        db 00h,0DCh,066h,066h,07Ch,060h,0F0h,00h,00h,076h,0CCh,0CCh,07Ch,0Ch,0Eh,00h
        db 00h,0DCh,076h,066h,060h,0F0h,00h,00h,00h,07Ch,0C0h,078h,0Ch,0F8h,00h,010h
        db 030h,07Ch,030h,030h,034h,018h,00h,00h,00h,0CCh,0CCh,0CCh,0CCh,076h,00h,00h
        db 00h,0CCh,0CCh,0CCh,078h,030h,00h,00h,00h,0C6h,0D6h,0FEh,0FEh,06Ch,00h,00h
        db 00h,0C6h,06Ch,038h,06Ch,0C6h,00h,00h,00h,0CCh,0CCh,0CCh,07Ch,0Ch,0F8h,00h
        db 00h,0FCh,098h,030h,064h,0FCh,00h,01Ch,030h,030h,0E0h,030h,030h,01Ch,00h,018h
        db 018h,018h,00h,018h,018h,018h,00h,0E0h,030h,030h,01Ch,030h,030h,0E0h,00h,076h
        db 0DCh,00h,00h,00h,00h,00h,00h,00h,010h,038h,06Ch,0C6h,0C6h,0FEh,00h,00h
        db 02h,04h,048h,050h,020h,00h,00h,018h,030h,060h,0FEh,060h,030h,018h,00h,030h
        db 018h,0Ch,0FEh,0Ch,018h,030h,00h,010h,038h,07Ch,0D6h,010h,010h,010h,00h,010h
        db 010h,010h,0D6h,07Ch,038h,010h,00h,00h,00h,00h,0FFh,00h,00h,00h,00h,010h
        db 010h,010h,010h,010h,010h,010h,010h,08h,024h,092h,092h,024h,08h,00h,00h,07Ch
        db 0C6h,092h,092h,0C6h,07Ch,00h,00h,00h,02h,04h,048h,050h,020h,00h,00h,00h
        db 020h,060h,0FEh,0FEh,060h,020h,00h,00h,00h,00h,00h,00h,00h,00h,0FFh,080h
        db 0C0h,0E0h,0F0h,0E0h,0C0h,080h,00h,00h,0F0h,088h,084h,084h,084h,07Ch,00h,030h
        db 048h,048h,0FCh,0FCh,0FCh,0FCh,00h,00h
__8087:                                         ; used by InitFpuFlags, __chk8087_
        db 00h
FpuType:                                        ; used by __chk8087_, __init_8087_, _fpreset_
        db 00h,00h,00h
