; Tables for the graphics library.
bits 32
%include "hockey.inc"
section s_EA034 nobits alloc noexec write align=1
global ZoneFlags, ZoneScreenLeft, ZoneScreenRight, ZoneScreenTop, ZoneScreenBottom, ZoneBoundsLeft, ZoneBoundsRight, ZoneBoundsTop
global ZoneBoundsBottom, ZoneCurRect, ZonePrevAdded, ZoneNodeRects, ZoneFreeHead, ZoneNewNode, ZoneListHead, ZoneListTail
global ZoneRects, ZoneMgrOn, ZoneListCount, ZoneRectsB, ZoneRectsA, ZoneMemBlock, ZonePrevStates, ZoneNextLinks
global ZonePrevRects, ZoneBufferParity, ZoneStates, ZoneStatesB, ZoneStatesA, HiddenWindow, BackgroundWindow, ZoneSlots
global ZoneOriginX, ZoneOriginY, ZoneSavedBottom, ZoneSavedRight, ZoneSavedLeft, ZoneSavedTop
ZoneScreenLeft:
        resb 4
ZoneScreenRight:
        resb 4
ZoneScreenTop:
        resb 4
ZoneScreenBottom:
        resb 4
ZoneBoundsLeft:
        resb 4
ZoneBoundsRight:
        resb 4
ZoneBoundsTop:
        resb 4
ZoneBoundsBottom:
        resb 4
ZoneCurRect:
        resb 4
ZoneFlags:
        resb 4
ZonePrevAdded:
        resb 4
ZoneNodeRects:
        resb 4
ZoneFreeHead:
        resb 4
ZoneNewNode:
        resb 4
ZoneListHead:
        resb 4
ZoneListTail:
        resb 4
ZoneRects:
        resb 4
ZoneMgrOn:
        resb 4
ZoneListCount:
        resb 4
ZoneRectsB:
        resb 4
ZoneRectsA:
        resb 4
ZoneMemBlock:
        resb 4
ZonePrevStates:
        resb 4
ZoneNextLinks:
        resb 4
ZonePrevRects:
        resb 4
ZoneBufferParity:
        resb 4
ZoneStates:
        resb 4
ZoneStatesB:
        resb 4
ZoneStatesA:
        resb 8
HiddenWindow:
        resb 4
BackgroundWindow:
        resb 4
ZoneSlots:
        resb 4
ZoneOriginX:
        resb 4
ZoneOriginY:
        resb 8
ZoneSavedBottom:
        resb 4
ZoneSavedRight:
        resb 4
ZoneSavedLeft:
        resb 4
ZoneSavedTop:
        resb 12
