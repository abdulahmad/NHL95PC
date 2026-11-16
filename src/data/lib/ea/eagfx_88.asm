; Tables for the graphics library.
bits 32
%include "hockey.inc"
section s_EA034 nobits alloc noexec write align=1
global ZoneFlags, ZoneScreenLeft, ZoneScreenRight, ZoneScreenTop, ZoneScreenBottom, ZoneBoundsLeft, ZoneBoundsRight, ZoneBoundsTop
global ZoneBoundsBottom, ZoneCurRect, ZonePrevAdded, ZoneNodeRects, ZoneFreeHead, ZoneNewNode, ZoneListHead, ZoneListTail
global ZoneRects, ZoneMgrOn, ZoneListCount, ZoneRectsB, ZoneRectsA, ZoneMemBlock, ZonePrevStates, ZoneNextLinks
global ZonePrevRects, ZoneBufferParity, ZoneStates, ZoneStatesB, ZoneStatesA, HiddenWindow, BackgroundWindow, ZoneSlots
global ZoneOriginX, ZoneOriginY, ZoneSavedBottom, ZoneSavedRight, ZoneSavedLeft, ZoneSavedTop
ZoneScreenLeft:                                 ; left edge of the zone manager screen; used by AddZone,
                                                ; BeginZoneFrame, ClampZoneToScreen ...
        resb 4
ZoneScreenRight:                                ; right edge of the zone manager screen; used by
                                                ; BeginZoneFrame, ClampZoneToScreen, ComputeZoneBounds ...
        resb 4
ZoneScreenTop:                                  ; top edge of the zone manager screen; used by BeginZoneFrame,
                                                ; ClampZoneToScreen, SetZoneScreen
        resb 4
ZoneScreenBottom:                               ; bottom edge of the zone manager screen; used by
                                                ; BeginZoneFrame, ClampZoneToScreen, ComputeZoneBounds ...
        resb 4
ZoneBoundsLeft:                                 ; left edge of the box around all zones; used by ClipToRect,
                                                ; ComputeZoneBounds
        resb 4
ZoneBoundsRight:                                ; right edge of the box around all zones; used by
                                                ; ComputeZoneBounds
        resb 4
ZoneBoundsTop:                                  ; top edge of the box around all zones; used by
                                                ; ComputeZoneBounds
        resb 4
ZoneBoundsBottom:                               ; bottom edge of the box around all zones; used by
                                                ; ComputeZoneBounds
        resb 4
ZoneCurRect:                                    ; zone rectangle being aligned or added; used by AlignZoneRect
        resb 4
ZoneFlags:                                      ; zone manager flags (bit 0 full redraw, bit 5 clip to zone
                                                ; bounds); used by BeginZoneFrame, ClearZoneFlags,
                                                ; ClipToZoneUpdate ...
        resb 4
ZonePrevAdded:                                  ; set when last frame's zones were already added this frame;
                                                ; used by BeginZoneFrame, ClipToZoneUpdate, FlushZones
        resb 4
ZoneNodeRects:                                  ; rectangles of the zone list nodes; used by AddZone,
                                                ; ComputeZoneBounds, EraseZones ...
        resb 4
ZoneFreeHead:                                   ; first free zone list node; used by FreeAllZones,
                                                ; InsertZoneSorted, RemoveZone
        resb 4
ZoneNewNode:                                    ; zone list node being added; used by AddZone,
                                                ; ClampZoneToScreen, InsertZoneSorted ...
        resb 4
ZoneListHead:                                   ; first node of the zone list; used by AddZone,
                                                ; ComputeZoneBounds, EraseZones ...
        resb 4
ZoneListTail:                                   ; last node of the zone list; used by FreeAllZones,
                                                ; InitZoneManager, InsertZoneSorted ...
        resb 4
ZoneRects:                                      ; this frame's dirty rectangle per zone slot; used by
                                                ; FlushZones, GetZoneRect, MarkZonePoint ...
        resb 4
ZoneMgrOn:                                      ; nonzero while the zone manager is set up; used by
                                                ; InitZoneManager, MarkZonePoint, MarkZonePoints ...
        resb 4
ZoneListCount:                                  ; number of nodes in the zone list; used by EraseZones,
                                                ; FreeAllZones, InitZoneManager ...
        resb 4
ZoneRectsB:                                     ; second buffer of dirty rectangles; used by InitZoneManager,
                                                ; SwapZoneLists
        resb 4
ZoneRectsA:                                     ; first buffer of dirty rectangles; used by InitZoneManager,
                                                ; SwapZoneLists
        resb 4
ZoneMemBlock:                                   ; memory block holding all zone tables; used by
                                                ; FreeZoneManager, InitZoneManager
        resb 4
ZonePrevStates:                                 ; last frame's state word per zone slot; used by
                                                ; BeginZoneFrame, FlushZones, SwapZoneLists
        resb 4
ZoneNextLinks:                                  ; next node index per zone list node; used by AddZone,
                                                ; ComputeZoneBounds, EraseZones ...
        resb 4
ZonePrevRects:                                  ; last frame's dirty rectangle per zone slot; used by
                                                ; BeginZoneFrame, FlushZones, SwapZoneLists
        resb 4
ZoneBufferParity:                               ; selects which rectangle and state buffer is current; used by
                                                ; FlushZones, InitZoneManager, SwapZoneLists
        resb 4
ZoneStates:                                     ; this frame's state word per zone slot; used by
                                                ; ClearZoneBits, FlushZones, GetZoneBits ...
        resb 4
ZoneStatesB:                                    ; second buffer of state words; used by InitZoneManager,
                                                ; SwapZoneLists
        resb 4
ZoneStatesA:                                    ; first buffer of state words; used by InitZoneManager,
                                                ; SwapZoneLists
        resb 8
HiddenWindow:                                   ; hidden (off-screen) bitmap that frames are drawn into; used
                                                ; by BeginZoneFrame, CopyHiddenToScreen, CopyZoneToScreen ...
        resb 4
BackgroundWindow:                               ; background bitmap used to erase zones; used by
                                                ; RestoreZoneRect, SelectBackgroundWindow, SetBackgroundWindow
        resb 4
ZoneSlots:                                      ; number of zone slots; used by AddMarkedZones, FlushZones,
                                                ; InitZoneManager ...
        resb 4
ZoneOriginX:                                    ; screen x of the hidden bitmap; used by ClipToZone,
                                                ; CopyHiddenToScreen, CopyZoneToScreen ...
        resb 4
ZoneOriginY:                                    ; screen y of the hidden bitmap; used by ClipToZone,
                                                ; CopyHiddenToScreen, CopyZoneToScreen ...
        resb 8
ZoneSavedBottom:                                ; bottom edge given to SetZoneScreen; used by SetZoneScreen
        resb 4
ZoneSavedRight:                                 ; right edge given to SetZoneScreen; used by SetZoneScreen
        resb 4
ZoneSavedLeft:                                  ; left edge given to SetZoneScreen; used by SetZoneScreen
        resb 4
ZoneSavedTop:                                   ; top edge given to SetZoneScreen; used by SetZoneScreen
        resb 12
