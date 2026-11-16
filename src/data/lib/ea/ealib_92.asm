; Tables for the EA libraries: the mouse, the clip rectangle, and the file and video state.
bits 32
%include "hockey.inc"
section s_EDAA8 nobits alloc noexec write align=1
global vesamodeok, MemDescriptorBase, MemDescriptorTop
global MemLockHandle, MemFreeBytes, vesapresent, ScreenWidthPtr, timercallbacks, vesamodeinfo, vesainfo
MemDescriptorBase:                              ; Lowest memory descriptor address checked by the shape and
                                                ; window code; used by FillRowTable, initmemman, removewindow
        resb 4
MemDescriptorTop:                               ; Memory descriptor top; used by InitMemDescriptors,
                                                ; PushMemDescriptor, getmemblock
        resb 4
MemLockHandle:                                  ; used by AllocMemBlockEx, CompactDownLocked, CompactUpLocked
                                                ; ...
        resb 4
MemFreeBytes:                                   ; Largest free memory figure kept by the memory tracker; used
                                                ; by DumpMemoryMap, DumpShapesList, MemTrackLargestFree ...
        resb 4
vesamodeinfo:                                   ; ProbeVesa: the 256-byte VBE mode information block (window
                                                ; attributes, granularity, segment); used by ProbeVesa,
                                                ; initgraphics
        resb 2
        resb 1
        resb 253
vesainfo:                                       ; ProbeVesa: the 256-byte VBE controller information block
                                                ; ('VESA', version, memory); used by ProbeVesa
        resb 18
        resb 238
vesapresent:                                    ; ProbeVesa: set when the VESA tables are filled; used by
                                                ; ProbeVesa, initgraphics
        resb 4
ScreenWidthPtr:                                 ; Pointer to the screen width; used by initgraphics
        resb 4
vesamodeok:                                     ; ProbeVesa: one flag per mode from 100h, 1Bh entries; used by
                                                ; ProbeVesa, initgraphics
        resb 1
        resb 2
        resb 2
        resb 2
        resb 21
timercallbacks:                                 ; used by CountTimerCallbacks, InstallTimer,
                                                ; RemoveTimerCallback ...
        resb 32
