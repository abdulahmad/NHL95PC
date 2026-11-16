; The zone manager. Windows on screen, and which one has the mouse.
bits 32
%include "hockey.inc"
section s_6A033 progbits alloc exec nowrite align=1
extern __CHK, str_ZMHiddenWindowNoHiddenWindow, str_ZMBackgroundWindowNo, str_ZONEMGR, TextCharH, ZoneFlags, ZoneScreenLeft, ZoneScreenRight
extern ZoneScreenTop, ZoneScreenBottom, ZoneBoundsLeft, ZoneBoundsRight, ZoneBoundsTop, ZoneBoundsBottom, ZoneCurRect, ZonePrevAdded
extern ZoneNodeRects, ZoneFreeHead, ZoneNewNode, ZoneListHead, ZoneListTail, ZoneRects, ZoneMgrOn, ZoneListCount
extern ZoneRectsB, ZoneRectsA, ZoneMemBlock, ZonePrevStates, ZoneNextLinks, ZonePrevRects, ZoneBufferParity, ZoneStates
extern ZoneStatesB, ZoneStatesA, HiddenWindow, BackgroundWindow, ZoneSlots, ZoneOriginX, ZoneOriginY, ZoneSavedBottom
extern ZoneSavedRight, ZoneSavedLeft, ZoneSavedTop, FatalError, fputchar, FreeMemBlock, memset_, SetDrawBitmap
extern AllocMemBlock, PutBlock, SetScreenTarget, SetClipWindow, FillRectColor
global SetZoneFlags, ClearZoneFlags, ToggleZoneFlags, GetZoneFlags, SetZoneBits, ClearZoneBits, ToggleZoneBits, GetZoneBits
global GetZoneRect, SetHiddenWindow, SelectHiddenWindow, SetBackgroundWindow, SelectBackgroundWindow, ClipToZone, CopyZoneToScreen, CopyHiddenToScreen
global AlignZoneRect, ZoneDebugHook, DrawRectOutline, OutlineZone, RestoreZoneRect, SwapZoneLists, FreeAllZones, ZoneCovered
global MergeZoneRect, ZoneOverlaps, ZoneOverlaps, ClampZoneToScreen, RemoveZone, InsertZoneSorted, SplitZoneRect, AddZone
global AddMarkedZones, InitZoneManager, FreeZoneManager, MarkZonePoint, MarkZoneRect, ZonePutChar, MarkZonePoints, MarkZoneRadius
global MarkZoneSprite, MarkZoneShapeAt, EraseZones, FlushZones, ComputeZoneBounds, SetZoneScreen, SetZoneOrigin, ClipToZoneScreen
global ClipToZoneUpdate, ClipToRect, BeginZoneFrame
SetZoneFlags:
        push dword 4
        call __CHK
        or dword [ZoneFlags], eax
        ret
ClearZoneFlags:
        push dword 4
        call __CHK
        not eax
        and dword [ZoneFlags], eax
        ret
ToggleZoneFlags:
        push dword 4
        call __CHK
        xor dword [ZoneFlags], eax
        ret
GetZoneFlags:
        push dword 4
        call __CHK
        mov eax, dword [ZoneFlags]
        ret
SetZoneBits:
        push dword 8
        call __CHK
        push ebx
        mov ebx, eax
        shl ebx, 2
        mov eax, dword [ZoneStates]
        or dword [ebx+eax], edx
        pop ebx
        ret
ClearZoneBits:
        push dword 8
        call __CHK
        push ebx
        mov ebx, dword [ZoneStates]
        not edx
        and dword [ebx+eax*4], edx
        pop ebx
        ret
ToggleZoneBits:
        push dword 8
        call __CHK
        push ebx
        mov ebx, eax
        shl ebx, 2
        mov eax, dword [ZoneStates]
        xor dword [ebx+eax], edx
        pop ebx
        ret
GetZoneBits:
        push dword 8
        call __CHK
        push edx
        mov edx, eax
        shl edx, 2
        mov eax, dword [ZoneStates]
        mov eax, dword [edx+eax]
        pop edx
        ret
GetZoneRect:
        push dword 8
        call __CHK
        push edx
        shl eax, 4
        mov edx, dword [ZoneRects]
        add eax, edx
        pop edx
        ret
SetHiddenWindow:
        push dword 4
        call __CHK
        mov dword [HiddenWindow], eax
        ret
SelectHiddenWindow:
        push dword 24h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        cmp dword [HiddenWindow], byte 0
        jne short .1
        push str_ZMHiddenWindowNoHiddenWindow
        call FatalError
        add esp, byte 4
.1:
        mov ebx, dword [HiddenWindow]
        push ebx
        call SetDrawBitmap
        add esp, byte 4
        mov eax, dword [HiddenWindow]
        mov ecx, dword [byte eax+04h]
        push ecx
        push byte 0
        mov esi, dword [eax]
        push esi
        push byte 0
        call SetClipWindow
        add esp, byte 10h
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
SetBackgroundWindow:
        push dword 4
        call __CHK
        mov dword [BackgroundWindow], eax
        ret
SelectBackgroundWindow:
        push dword 24h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        cmp dword [BackgroundWindow], byte 0
        jne short .1
        push str_ZMBackgroundWindowNo
        call FatalError
        add esp, byte 4
.1:
        mov ebx, dword [BackgroundWindow]
        push ebx
        call SetDrawBitmap
        add esp, byte 4
        mov eax, dword [BackgroundWindow]
        jmp short SelectHiddenWindow+038h
ClipToZone:
        push dword 24h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov edx, dword [byte eax+0Ch]
        mov ebx, dword [ZoneOriginY]
        add edx, ebx
        push edx
        mov edx, dword [byte eax+08h]
        add edx, ebx
        push edx
        mov edx, dword [byte eax+04h]
        mov esi, dword [ZoneOriginX]
        add edx, esi
        push edx
        mov eax, dword [eax]
        add eax, esi
        push eax
        jmp near SelectHiddenWindow+043h
CopyZoneToScreen:
        push dword 28h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push ebp
        mov edx, dword [byte eax+0Ch]
        mov ebx, dword [ZoneOriginY]
        add edx, ebx
        push edx
        mov edx, dword [byte eax+08h]
        add edx, ebx
        push edx
        mov edx, dword [byte eax+04h]
        mov esi, dword [ZoneOriginX]
        add edx, esi
        push edx
        mov eax, dword [eax]
        add eax, esi
        push eax
        call SetClipWindow
        add esp, byte 10h
        mov ebp, dword [ZoneOriginY]
        push ebp
        mov eax, dword [ZoneOriginX]
        push eax
        mov eax, dword [HiddenWindow]
        mov edx, dword [byte eax+02Ch]
        push edx
        call PutBlock
        add esp, byte 0Ch
        pop ebp
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
CopyHiddenToScreen:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push dword 0A8h
        push byte 0
        push dword 140h
        push byte 0
        call SetClipWindow
        add esp, byte 10h
        mov edx, dword [ZoneOriginY]
        push edx
        mov ebx, dword [ZoneOriginX]
        push ebx
        mov eax, dword [HiddenWindow]
        mov ecx, dword [byte eax+02Ch]
        push ecx
        call PutBlock
        add esp, byte 0Ch
        pop edx
        pop ecx
        pop ebx
        ret
AlignZoneRect:
        push dword 8
        call __CHK
        push edx
        mov eax, dword [ZoneCurRect]
        add dword [byte eax+04h], byte 2
        mov eax, dword [ZoneCurRect]
        mov edx, dword [eax]
        sar edx, 2
        shl edx, 2
        mov dword [eax], edx
        mov eax, dword [ZoneCurRect]
        mov edx, dword [byte eax+04h]
        dec edx
        sar edx, 2
        shl edx, 2
        add edx, byte 4
        mov dword [byte eax+04h], edx
        mov eax, dword [ZoneCurRect]
        inc dword [byte eax+0Ch]
        pop edx
        ret
ZoneDebugHook:
        push dword 4
        call __CHK
        ret
DrawRectOutline:
        push dword 28h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov esi, eax
        mov edi, edx
        mov ebp, ebx
        mov dword [esp], ecx
        mov edx, dword [byte esp+014h]
        push edx
        push ecx
        push eax
        push edi
        push eax
        call FillRectColor
        add esp, byte 14h
        mov ecx, dword [byte esp+014h]
        push ecx
        mov eax, dword [byte esp+04h]
        push eax
        push ebp
        push eax
        push esi
        call FillRectColor
        add esp, byte 14h
        mov ebx, dword [byte esp+014h]
        push ebx
        push edi
        push ebp
        mov ecx, dword [byte esp+0Ch]
        push ecx
        push ebp
        call FillRectColor
        add esp, byte 14h
        mov eax, dword [byte esp+014h]
        push eax
        push edi
        push esi
        push edi
        push ebp
        call FillRectColor
        add esp, byte 14h
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        ret 4
OutlineZone:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push esi
        push edx
        mov edx, dword [byte eax+0Ch]
        add edx, dword [ZoneOriginY]
        lea ecx, [byte edx-01h]
        mov edx, dword [byte eax+04h]
        mov esi, dword [ZoneOriginX]
        add edx, esi
        lea ebx, [byte edx-01h]
        mov edx, dword [byte eax+08h]
        add edx, dword [ZoneOriginY]
        mov eax, dword [eax]
        add eax, esi
        call DrawRectOutline
        pop esi
        pop ecx
        pop ebx
        ret
RestoreZoneRect:
        push dword 2Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        mov edx, dword [byte eax+0Ch]
        push edx
        mov ebx, dword [byte eax+08h]
        push ebx
        mov ecx, dword [byte eax+04h]
        push ecx
        mov esi, dword [eax]
        push esi
        call SetClipWindow
        add esp, byte 10h
        mov edi, dword [ZoneOriginY]
        push edi
        mov ebp, dword [ZoneOriginX]
        push ebp
        mov eax, dword [BackgroundWindow]
        mov edx, dword [byte eax+02Ch]
        push edx
        call PutBlock
        add esp, byte 0Ch
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
SwapZoneLists:
        push dword 0Ch
        call __CHK
        push ebx
        push edx
        cmp dword [ZoneBufferParity], byte 0
        je short .1
        mov eax, dword [ZoneRectsB]
        mov dword [ZoneRects], eax
        mov eax, dword [ZoneStatesA]
        mov dword [ZoneStates], eax
        mov eax, dword [ZoneRectsA]
        mov dword [ZonePrevRects], eax
        mov eax, dword [ZoneStatesB]
        jmp short .2
.1:
        mov eax, dword [ZoneRectsA]
        mov dword [ZoneRects], eax
        mov eax, dword [ZoneStatesB]
        mov dword [ZoneStates], eax
        mov eax, dword [ZoneRectsB]
        mov dword [ZonePrevRects], eax
        mov eax, dword [ZoneStatesA]
.2:
        mov dword [ZonePrevStates], eax
        mov ebx, dword [ZoneSlots]
        add ebx, ebx
        mov eax, dword [ZoneStates]
        xor edx, edx
        call memset_
        pop edx
        pop ebx
        ret
FreeAllZones:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        cmp dword [ZoneListCount], byte 0
        je short .1
        mov edx, dword [ZoneFreeHead]
        shl edx, 2
        mov eax, dword [ZoneNextLinks]
        add eax, edx
        mov edx, dword [ZoneListTail]
        mov dword [eax], edx
        xor ebx, ebx
        mov dword [ZoneListCount], ebx
        mov eax, dword [ZoneListHead]
        mov dword [ZoneListTail], eax
.1:
        mov ecx, 0FFFFFFFFh
        mov dword [ZoneFreeHead], ecx
        mov dword [ZoneListHead], ecx
        pop edx
        pop ecx
        pop ebx
        ret
ZoneCovered:
        push dword 0Ch
        call __CHK
        push ebx
        push edx
        mov edx, dword [ZoneNewNode]
        mov ebx, dword [byte eax+0Ch]
        cmp ebx, dword [byte edx+0Ch]
        jge short .2
.1:
        xor eax, eax
        pop edx
        pop ebx
        ret
.2:
        mov ebx, dword [byte eax+04h]
        cmp ebx, dword [byte edx+04h]
        jl short .1
        mov ebx, dword [eax]
        cmp ebx, dword [edx]
        jg short .1
        mov eax, dword [byte eax+08h]
        cmp eax, dword [byte edx+08h]
        jle short .3
        mov eax, 2
        pop edx
        pop ebx
        ret
.3:
        mov eax, 1
        pop edx
        pop ebx
        ret
MergeZoneRect:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov edx, dword [ZoneNewNode]
        mov ebx, dword [byte eax+0Ch]
        cmp ebx, dword [byte edx+08h]
        jne short .8
        mov ebx, dword [eax]
        sub ebx, dword [edx]
        test ebx, ebx
        jge short .1
        mov edx, ebx
        neg edx
        jmp short .2
.1:
        mov edx, ebx
.2:
        cmp edx, byte 10h
        jg near .14
        mov ecx, dword [ZoneNewNode]
        mov edx, dword [byte eax+04h]
        sub edx, dword [byte ecx+04h]
        test edx, edx
        jge short .3
        mov ecx, edx
        neg ecx
        jmp short .4
.3:
        mov ecx, edx
.4:
        cmp ecx, byte 10h
        jg near .14
        mov ecx, dword [ZoneNewNode]
        mov ecx, dword [byte ecx+0Ch]
        mov dword [byte eax+0Ch], ecx
.5:
        test edx, edx
        jge short .6
        sub dword [byte eax+04h], edx
.6:
        test ebx, ebx
        jle short .7
        sub dword [eax], ebx
.7:
        mov edx, 1
        jmp short .15
.8:
        mov ebx, dword [byte eax+08h]
        mov esi, dword [byte edx+0Ch]
        cmp ebx, esi
        jne short .13
        mov ebx, dword [eax]
        sub ebx, dword [edx]
        test ebx, ebx
        jge short .9
        mov edx, ebx
        neg edx
        jmp short .10
.9:
        mov edx, ebx
.10:
        cmp edx, byte 10h
        jg short .14
        mov ecx, dword [ZoneNewNode]
        mov edx, dword [byte eax+04h]
        sub edx, dword [byte ecx+04h]
        test edx, edx
        jge short .11
        mov ecx, edx
        neg ecx
        jmp short .12
.11:
        mov ecx, edx
.12:
        cmp ecx, byte 10h
        jg short .14
        mov ecx, dword [ZoneNewNode]
        mov ecx, dword [byte ecx+08h]
        mov dword [byte eax+08h], ecx
        jmp short .5
.13:
        jle short .14
        mov edx, 2
        jmp short .15
.14:
        xor edx, edx
.15:
        mov eax, edx
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
ZoneOverlaps:
        push dword 0Ch
        call __CHK
        push ebx
        push edx
        mov edx, dword [ZoneNewNode]
        mov ebx, dword [byte eax+0Ch]
        cmp ebx, dword [byte edx+08h]
        jg short .2
.1:
        xor eax, eax
        pop edx
        pop ebx
        ret
.2:
        mov ebx, dword [byte eax+04h]
        cmp ebx, dword [edx]
        jle short .1
        mov ebx, dword [eax]
        cmp ebx, dword [byte edx+04h]
        jge short .1
        mov eax, dword [byte eax+08h]
        cmp eax, dword [byte edx+0Ch]
        jl short .3
        mov eax, 2
        pop edx
        pop ebx
        ret
.3:
        mov eax, 1
        pop edx
        pop ebx
        ret
ClampZoneToScreen:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        mov eax, dword [ZoneNewNode]
        mov edx, dword [eax]
        mov ebx, dword [ZoneScreenLeft]
        cmp edx, ebx
        jge short .1
        mov dword [eax], ebx
.1:
        mov eax, dword [ZoneNewNode]
        mov edx, dword [byte eax+08h]
        mov ecx, dword [ZoneScreenTop]
        cmp edx, ecx
        jge short .2
        mov dword [byte eax+08h], ecx
.2:
        mov eax, dword [ZoneNewNode]
        mov edx, dword [ZoneScreenRight]
        cmp edx, dword [byte eax+04h]
        jge short .3
        mov dword [byte eax+04h], edx
.3:
        mov eax, dword [ZoneNewNode]
        mov edx, dword [ZoneScreenBottom]
        cmp edx, dword [byte eax+0Ch]
        jge short .4
        mov dword [byte eax+0Ch], edx
.4:
        pop edx
        pop ecx
        pop ebx
        ret
RemoveZone:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov ebx, eax
        mov ecx, 0FFFFFFFFh
        mov eax, dword [ZoneListHead]
        mov edx, dword [ZoneNextLinks]
.1:
        cmp eax, byte 0FFFFFFFFh
        je short .2
        cmp eax, ebx
        je short .2
        mov ecx, eax
        mov eax, dword [edx+eax*4]
        jmp short .1
.2:
        mov edx, dword [ZoneNextLinks]
        mov eax, dword [edx+eax*4]
        cmp ecx, byte 0FFFFFFFFh
        jne short .3
        mov eax, ebx
        mov eax, dword [edx+eax*4]
        mov dword [ZoneListHead], eax
        jmp short .4
.3:
        mov esi, ecx
        mov dword [edx+esi*4], eax
.4:
        cmp ebx, dword [ZoneFreeHead]
        jne short .5
        mov dword [ZoneFreeHead], ecx
.5:
        mov eax, ebx
        shl eax, 2
        mov edx, dword [ZoneNextLinks]
        add eax, edx
        mov edx, dword [ZoneListTail]
        mov dword [eax], edx
        mov dword [ZoneListTail], ebx
        dec dword [ZoneListCount]
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
InsertZoneSorted:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov eax, dword [ZoneListHead]
        mov ecx, 0FFFFFFFFh
.1:
        cmp eax, byte 0FFFFFFFFh
        je short .2
        mov edx, eax
        shl edx, 4
        mov ebx, dword [ZoneNodeRects]
        add ebx, edx
        mov edx, dword [ZoneNewNode]
        mov edx, dword [byte edx+08h]
        cmp edx, dword [byte ebx+08h]
        jl short .2
        mov ecx, eax
        mov edx, dword [ZoneNextLinks]
        mov eax, dword [edx+eax*4]
        jmp short .1
.2:
        mov eax, dword [ZoneListTail]
        mov esi, eax
        shl esi, 2
        mov ebx, dword [ZoneNextLinks]
        lea edx, [ebx+esi]
        mov edi, dword [edx]
        mov dword [ZoneListTail], edi
        cmp ecx, byte 0FFFFFFFFh
        je short .3
        mov edx, ecx
        shl edx, 2
        add edx, ebx
        mov ebx, dword [edx]
        mov dword [edx], eax
        mov edx, dword [ZoneNextLinks]
        mov dword [edx+esi], ebx
        jmp short .4
.3:
        mov ebx, dword [ZoneListHead]
        mov dword [edx], ebx
        mov dword [ZoneListHead], eax
.4:
        cmp ecx, dword [ZoneFreeHead]
        jne short .5
        mov dword [ZoneFreeHead], eax
        mov edx, eax
        mov ebx, dword [ZoneNextLinks]
        mov dword [ebx+edx*4], 0FFFFFFFFh
.5:
        mov esi, dword [ZoneNewNode]
        shl eax, 4
        mov edi, dword [ZoneNodeRects]
        add edi, eax
        movsd
        movsd
        movsd
        movsd
        inc dword [ZoneListCount]
        jmp near RestoreZoneRect+047h
SplitZoneRect:
        push dword 4Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 30h
        mov ecx, eax
        mov edx, eax
        shl edx, 4
        mov eax, dword [ZoneNodeRects]
        add edx, eax
        lea edi, [byte esp+020h]
        mov esi, edx
        movsd
        movsd
        movsd
        movsd
        mov ebx, dword [ZoneNewNode]
        mov eax, dword [byte edx+08h]
        mov esi, dword [byte ebx+08h]
        cmp eax, esi
        jge short .2
        lea edi, [byte esp+010h]
        mov esi, edx
        movsd
        movsd
        movsd
        movsd
        mov eax, dword [byte ebx+08h]
        mov dword [byte esp+01Ch], eax
        mov dword [byte esp+028h], eax
.1:
        mov ebp, 1
        jmp short .4
.2:
        cmp esi, eax
        jge short .3
        lea edi, [byte esp+010h]
        mov esi, ebx
        movsd
        movsd
        movsd
        movsd
        mov eax, dword [byte edx+08h]
        mov dword [byte esp+01Ch], eax
        jmp short .1
.3:
        xor ebp, ebp
.4:
        mov ebx, dword [ZoneNewNode]
        mov eax, dword [byte edx+0Ch]
        mov esi, dword [byte ebx+0Ch]
        cmp eax, esi
        jle short .6
        mov edi, esp
        mov esi, edx
        movsd
        movsd
        movsd
        movsd
        mov eax, dword [byte ebx+0Ch]
        mov dword [byte esp+08h], eax
        mov dword [byte esp+02Ch], eax
.5:
        mov esi, 1
        jmp short .8
.6:
        cmp esi, eax
        jle short .7
        mov edi, esp
        mov esi, ebx
        movsd
        movsd
        movsd
        movsd
        mov eax, dword [byte edx+0Ch]
        mov dword [byte esp+08h], eax
        jmp short .5
.7:
        xor esi, esi
.8:
        mov eax, dword [ZoneNewNode]
        mov ebx, dword [eax]
        mov edi, dword [edx]
        cmp ebx, edi
        jge short .9
        mov eax, ebx
        jmp short .10
.9:
        mov eax, edi
.10:
        mov dword [byte esp+020h], eax
        mov eax, dword [ZoneNewNode]
        mov ebx, dword [byte eax+04h]
        mov edi, dword [byte edx+04h]
        cmp ebx, edi
        jle short .11
        mov eax, ebx
        jmp short .12
.11:
        mov eax, edi
.12:
        mov dword [byte esp+024h], eax
        mov eax, ecx
        call RemoveZone
        test ebp, ebp
        je short .13
        mov edx, 1
        lea eax, [byte esp+010h]
        call AddZone
.13:
        mov edx, 1
        lea eax, [byte esp+020h]
        call AddZone
        test esi, esi
        je short .14
        mov edx, 1
        mov eax, esp
        call AddZone
.14:
        add esp, byte 30h
        jmp near RestoreZoneRect+046h
AddZone:
        push dword 8
        call __CHK
        push ebx
        mov dword [ZoneNewNode], eax
        test edx, edx
        jne short .3
        mov eax, ZoneScreenLeft
        call ZoneOverlaps
        test eax, eax
        je near .11
        call ClampZoneToScreen
        mov edx, dword [ZoneListHead]
.1:
        cmp edx, byte 0FFFFFFFFh
        je short .3
        mov eax, edx
        shl eax, 4
        mov ebx, dword [ZoneNodeRects]
        add eax, ebx
        call ZoneCovered
        cmp eax, byte 1
        jb short .2
        jbe near .11
        cmp eax, byte 2
        je short .3
.2:
        mov eax, edx
        mov edx, dword [ZoneNextLinks]
        mov edx, dword [edx+eax*4]
        jmp short .1
.3:
        mov edx, dword [ZoneListHead]
.4:
        cmp edx, byte 0FFFFFFFFh
        je short .7
        mov eax, edx
        shl eax, 4
        mov ebx, dword [ZoneNodeRects]
        add eax, ebx
        call ZoneOverlaps
        cmp eax, byte 1
        jb short .6
        jbe short .5
        cmp eax, byte 2
        je short .7
        jmp short .6
.5:
        mov eax, edx
        call SplitZoneRect
        pop ebx
        ret
.6:
        mov eax, dword [ZoneNextLinks]
        mov edx, dword [eax+edx*4]
        jmp short .4
.7:
        mov edx, dword [ZoneListHead]
.8:
        cmp edx, byte 0FFFFFFFFh
        je short .10
        mov ebx, edx
        shl ebx, 4
        mov eax, dword [ZoneNodeRects]
        add eax, ebx
        call MergeZoneRect
        cmp eax, byte 1
        jb short .9
        jbe short .11
        cmp eax, byte 2
        je short .10
.9:
        mov eax, edx
        mov edx, dword [ZoneNextLinks]
        mov edx, dword [edx+eax*4]
        jmp short .8
.10:
        call InsertZoneSorted
.11:
        pop ebx
        ret
AddMarkedZones:
        push dword 0Ch
        call __CHK
        push ecx
        push esi
        mov esi, eax
        mov ecx, edx
        mov ebx, dword [ZoneSlots]
        shl ebx, 2
        add ebx, edx
.1:
        test byte [ecx], 4
        je short .2
        xor edx, edx
        mov eax, esi
        call AddZone
.2:
        add esi, byte 10h
        add ecx, byte 4
        cmp ecx, ebx
        setb al
        and eax, 0FFh
        jne short .1
        pop esi
        pop ecx
        ret
InitZoneManager:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push edi
        test eax, eax
        jne short .1
        mov dword [ZoneMgrOn], eax
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
.1:
        mov dword [ZoneMgrOn], 1
        mov dword [ZoneSlots], eax
        xor ebx, ebx
        mov dword [ZoneBufferParity], ebx
        push byte 20h
        mov edx, eax
        shl eax, 2
        add eax, edx
        shl eax, 4
        push eax
        push str_ZONEMGR
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [ZoneMemBlock], eax
        mov dword [ZoneRectsA], eax
        mov edx, dword [ZoneSlots]
        shl edx, 4
        add eax, edx
        mov dword [ZoneRectsB], eax
        add eax, edx
        mov dword [ZoneNodeRects], eax
        mov eax, dword [ZoneSlots]
        shl eax, 5
        mov edx, dword [ZoneNodeRects]
        add edx, eax
        mov dword [ZoneStatesB], edx
        mov eax, dword [ZoneSlots]
        shl eax, 2
        add edx, eax
        mov dword [ZoneStatesA], edx
        add edx, eax
        mov dword [ZoneNextLinks], edx
        xor eax, eax
        jmp short .3
.2:
        mov ebx, eax
        mov edx, dword [ZoneStatesA]
        mov dword [edx+ebx*4], 0
        mov ecx, dword [edx+ebx*4]
        mov edx, dword [ZoneStatesB]
        mov dword [edx+ebx*4], ecx
        inc eax
.3:
        cmp eax, dword [ZoneSlots]
        jl short .2
        xor edi, edi
        mov dword [ZoneListTail], edi
        mov dword [ZoneListCount], edi
        xor eax, eax
        jmp short .5
.4:
        mov ebx, eax
        mov edx, dword [ZoneNextLinks]
        inc eax
        mov dword [edx+ebx*4], eax
.5:
        mov edx, dword [ZoneSlots]
        add edx, edx
        dec edx
        cmp eax, edx
        jl short .4
        mov edx, dword [ZoneSlots]
        mov eax, dword [ZoneNextLinks]
        mov dword [byte eax+edx*8-04h], 0FFFFFFFFh
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
FreeZoneManager:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        mov edx, dword [ZoneMemBlock]
        push edx
        call FreeMemBlock
        add esp, byte 4
        pop edx
        pop ecx
        pop ebx
        ret
MarkZonePoint:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push esi
        mov ecx, eax
        mov ebx, edx
        cmp dword [ZoneMgrOn], byte 0
        je near .5
        cmp eax, dword [ZoneSlots]
        jg short .5
        shl eax, 4
        mov edx, dword [ZoneRects]
        add eax, edx
        mov edx, dword [ebx]
        mov ebx, dword [byte ebx+04h]
        mov esi, ecx
        shl esi, 2
        mov ecx, dword [ZoneStates]
        test byte [ecx+esi], 4
        jne short .1
        mov dword [byte eax+04h], edx
        mov dword [eax], edx
        mov dword [byte eax+0Ch], ebx
        mov dword [byte eax+08h], ebx
        mov eax, dword [ZoneStates]
        or byte [esi+eax], 4
        pop esi
        pop ecx
        pop ebx
        ret
.1:
        cmp edx, dword [eax]
        jge short .2
        mov dword [eax], edx
        jmp short .3
.2:
        cmp edx, dword [byte eax+04h]
        jle short .3
        mov dword [byte eax+04h], edx
.3:
        cmp ebx, dword [byte eax+08h]
        jge short .4
        mov dword [byte eax+08h], ebx
        pop esi
        pop ecx
        pop ebx
        ret
.4:
        cmp ebx, dword [byte eax+0Ch]
        jle short .5
        mov dword [byte eax+0Ch], ebx
.5:
        pop esi
        pop ecx
        pop ebx
        ret
MarkZoneRect:
        push dword 0Ch
        call __CHK
        push esi
        push edi
        mov esi, eax
        cmp dword [ZoneMgrOn], byte 0
        je short .5
        cmp eax, dword [ZoneSlots]
        jg short .5
        shl eax, 4
        mov edi, dword [ZoneRects]
        add eax, edi
        shl esi, 2
        mov edi, dword [ZoneStates]
        test byte [edi+esi], 4
        jne short .1
        mov dword [eax], edx
        mov dword [byte eax+04h], ecx
        mov dword [byte eax+08h], ebx
        mov edx, dword [byte esp+0Ch]
        mov dword [byte eax+0Ch], edx
        mov eax, dword [ZoneStates]
        or byte [esi+eax], 4
        pop edi
        pop esi
        ret 4
.1:
        cmp edx, dword [eax]
        jge short .2
        mov dword [eax], edx
.2:
        cmp ecx, dword [byte eax+04h]
        jle short .3
        mov dword [byte eax+04h], ecx
.3:
        cmp ebx, dword [byte eax+08h]
        jge short .4
        mov dword [byte eax+08h], ebx
.4:
        mov edx, dword [byte esp+0Ch]
        cmp edx, dword [byte eax+0Ch]
        jle short .5
        mov dword [byte eax+0Ch], edx
.5:
        pop edi
        pop esi
        ret 4
ZonePutChar:
        push dword 14h
        call __CHK
        push esi
        push edi
        push ebp
        mov ebp, eax
        mov edi, ebx
        mov esi, ecx
        xor eax, eax
        mov al, byte [TextCharH]
        add eax, ecx
        push eax
        push edx
        call fputchar
        add esp, byte 4
        lea ecx, [edi+eax]
        mov ebx, esi
        mov edx, edi
        mov eax, ebp
        call MarkZoneRect
        pop ebp
        pop edi
        pop esi
        ret
MarkZonePoints:
        push dword 1Ch
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        push eax
        mov eax, ebx
        cmp dword [ZoneMgrOn], byte 0
        je short .6
        test edx, edx
        je short .6
        mov ecx, dword [esp]
        cmp ecx, dword [ZoneSlots]
        jg short .6
        mov ecx, dword [ebx]
        mov edi, ecx
        mov esi, dword [byte ebx+04h]
        mov ebx, esi
.1:
        dec edx
        je short .5
        add eax, byte 8
        mov ebp, dword [eax]
        cmp edi, ebp
        jle short .2
        mov edi, ebp
        jmp short .3
.2:
        cmp ecx, ebp
        jg short .3
        lea ecx, [byte ebp+01h]
.3:
        mov ebp, dword [byte eax+04h]
        cmp ebx, ebp
        jle short .4
        mov ebx, ebp
        jmp short .1
.4:
        cmp esi, ebp
        jg short .1
        lea esi, [byte ebp+01h]
        jmp short .1
.5:
        push esi
        mov edx, edi
        mov eax, dword [byte esp+04h]
        call MarkZoneRect
.6:
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
MarkZoneRadius:
        push dword 18h
        call __CHK
        push esi
        push edi
        sub esp, byte 8
        test ecx, ecx
        jne short .1
        mov dword [esp], edx
        mov dword [byte esp+04h], ebx
        mov edx, esp
        call MarkZonePoint
        jmp short .2
.1:
        mov esi, ecx
        sar esi, 2
        mov edi, ecx
        sub edi, esi
        mov esi, edi
        add edi, ebx
        dec edi
        push edi
        lea edi, [edx+ecx]
        sub ebx, esi
        inc ebx
        sub edx, ecx
        mov ecx, edi
        call MarkZoneRect
.2:
        add esp, byte 8
        pop edi
        pop esi
        ret
MarkZoneSprite:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push esi
        mov esi, eax
        mov ebx, dword [byte edx+0Ch]
        sar ebx, 10h
        mov eax, dword [byte edx+04h]
        sar eax, 10h
        add eax, ebx
        push eax
        mov eax, dword [byte edx+0Ah]
        sar eax, 10h
        mov ecx, dword [byte edx+02h]
        sar ecx, 10h
        add ecx, eax
        mov edx, eax
        mov eax, esi
        call MarkZoneRect
        pop esi
        pop ecx
        pop ebx
        ret
MarkZoneShapeAt:
        push dword 0Ch
        call __CHK
        push esi
        mov esi, eax
        mov eax, ebx
        mov ebx, ecx
        mov ecx, dword [byte edx+04h]
        sar ecx, 10h
        add ecx, ebx
        push ecx
        mov ecx, dword [byte edx+02h]
        sar ecx, 10h
        add ecx, eax
        mov edx, eax
        mov eax, esi
        call MarkZoneRect
        pop esi
        ret
EraseZones:
        push dword 0Ch
        call __CHK
        push ebx
        push edx
        cmp dword [ZoneListCount], byte 0
        je short .1
        test byte [ZoneFlags], 41h
        je short .2
.1:
        mov eax, ZoneScreenLeft
        call RestoreZoneRect
        pop edx
        pop ebx
        ret
.2:
        mov edx, dword [ZoneListHead]
.3:
        cmp edx, byte 0FFFFFFFFh
        je near ZoneOverlaps+042h
        mov ebx, edx
        shl ebx, 4
        mov eax, dword [ZoneNodeRects]
        add eax, ebx
        call RestoreZoneRect
        mov eax, edx
        mov edx, dword [ZoneNextLinks]
        mov edx, dword [edx+eax*4]
        jmp short .3
FlushZones:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        call SetScreenTarget
        mov edx, dword [ZoneStates]
        mov eax, dword [ZoneRects]
        call ZoneDebugHook
        cmp dword [ZoneSlots], byte 0
        je short .1
        test byte [ZoneFlags], 42h
        je short .2
.1:
        call CopyHiddenToScreen
        and byte [ZoneFlags], 0FDh
        jmp short .5
.2:
        cmp dword [ZonePrevAdded], byte 0
        jne short .3
        call FreeAllZones
        mov edx, dword [ZonePrevStates]
        mov eax, dword [ZonePrevRects]
        mov ebx, 1
        call AddMarkedZones
.3:
        mov edx, dword [ZoneStates]
        mov eax, dword [ZoneRects]
        xor ebx, ebx
        call AddMarkedZones
        mov edx, dword [ZoneListHead]
.4:
        cmp edx, byte 0FFFFFFFFh
        je short .5
        mov ebx, edx
        shl ebx, 4
        mov eax, dword [ZoneNodeRects]
        add eax, ebx
        call CopyZoneToScreen
        mov eax, dword [ZoneNextLinks]
        mov edx, dword [eax+edx*4]
        jmp short .4
.5:
        cmp dword [ZoneBufferParity], byte 0
        sete al
        and eax, 0FFh
        mov dword [ZoneBufferParity], eax
        pop edx
        pop ecx
        pop ebx
        ret
ComputeZoneBounds:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        mov edx, 3E7h
        mov eax, dword [ZoneListHead]
        mov ecx, dword [ZoneNodeRects]
.1:
        cmp eax, byte 0FFFFFFFFh
        je short .3
        mov ebx, eax
        shl ebx, 4
        mov ebx, dword [ecx+ebx]
        cmp ebx, edx
        jge short .2
        mov edx, ebx
.2:
        test edx, edx
        je short .3
        mov ebx, dword [ZoneNextLinks]
        mov eax, dword [ebx+eax*4]
        jmp short .1
.3:
        mov dword [ZoneBoundsLeft], edx
        xor edx, edx
        mov eax, dword [ZoneListHead]
        mov ecx, dword [ZoneNodeRects]
.4:
        cmp eax, byte 0FFFFFFFFh
        je short .6
        mov ebx, eax
        shl ebx, 4
        mov ebx, dword [byte ecx+ebx+04h]
        cmp ebx, edx
        jle short .5
        mov edx, ebx
.5:
        cmp edx, dword [ZoneScreenRight]
        jge short .6
        mov ebx, dword [ZoneNextLinks]
        mov eax, dword [ebx+eax*4]
        jmp short .4
.6:
        mov dword [ZoneBoundsRight], edx
        mov edx, 3E7h
        mov eax, dword [ZoneListHead]
        mov ecx, dword [ZoneNodeRects]
.7:
        cmp eax, byte 0FFFFFFFFh
        je short .9
        mov ebx, eax
        shl ebx, 4
        mov ebx, dword [byte ecx+ebx+08h]
        cmp ebx, edx
        jge short .8
        mov edx, ebx
.8:
        test edx, edx
        je short .9
        mov ebx, dword [ZoneNextLinks]
        mov eax, dword [ebx+eax*4]
        jmp short .7
.9:
        mov dword [ZoneBoundsTop], edx
        xor edx, edx
        mov eax, dword [ZoneListHead]
.10:
        cmp eax, byte 0FFFFFFFFh
        je short .12
        mov ebx, eax
        shl ebx, 4
        mov ecx, dword [ZoneNodeRects]
        mov ebx, dword [byte ecx+ebx+0Ch]
        cmp ebx, edx
        jle short .11
        mov edx, ebx
.11:
        cmp edx, dword [ZoneScreenBottom]
        jge short .12
        mov ebx, dword [ZoneNextLinks]
        mov eax, dword [ebx+eax*4]
        jmp short .10
.12:
        mov dword [ZoneBoundsBottom], edx
        pop edx
        pop ecx
        pop ebx
        ret
SetZoneScreen:
        push dword 14h
        call __CHK
        mov dword [ZoneSavedLeft], eax
        mov dword [ZoneScreenLeft], eax
        mov dword [ZoneSavedRight], ebx
        mov dword [ZoneScreenRight], ebx
        mov dword [ZoneSavedTop], edx
        mov dword [ZoneScreenTop], edx
        mov dword [ZoneSavedBottom], ecx
        mov dword [ZoneScreenBottom], ecx
        push ecx
        push edx
        push ebx
        push eax
        call SetClipWindow
        add esp, byte 10h
        ret
SetZoneOrigin:
        push dword 4
        call __CHK
        mov dword [ZoneOriginX], eax
        mov dword [ZoneOriginY], edx
        ret
ClipToZoneScreen:
        push dword 4
        call __CHK
        mov eax, ZoneScreenLeft
        jmp short ClipToRect
ClipToZoneUpdate:
        push dword 4
        call __CHK
        test byte [ZoneFlags], 20h
        je short .1
        cmp dword [ZonePrevAdded], byte 0
        jne short ClipToRect+022h
.1:
        mov eax, ZoneScreenLeft
ClipToRect:
        push dword 24h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov edx, dword [byte eax+0Ch]
        push edx
        mov ebx, dword [byte eax+08h]
        push ebx
        mov ecx, dword [byte eax+04h]
        push ecx
        mov esi, dword [eax]
        push esi
        jmp near SelectHiddenWindow+043h
        mov eax, ZoneBoundsLeft
        jmp short ClipToRect
BeginZoneFrame:
        push dword 2Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        mov edx, dword [HiddenWindow]
        push edx
        call SetDrawBitmap
        add esp, byte 4
        call SwapZoneLists
        test byte [ZoneFlags], 1
        je short .1
        xor ecx, ecx
        mov dword [ZonePrevAdded], ecx
        jmp short .2
.1:
        mov ebx, 1
        mov dword [ZonePrevAdded], ebx
        call FreeAllZones
        mov edx, dword [ZonePrevStates]
        mov eax, dword [ZonePrevRects]
        call AddMarkedZones
.2:
        call EraseZones
        and byte [ZoneFlags], 0FEh
        mov esi, dword [ZoneScreenBottom]
        push esi
        mov edi, dword [ZoneScreenTop]
        push edi
        mov ebp, dword [ZoneScreenRight]
        push ebp
        mov eax, dword [ZoneScreenLeft]
        push eax
        call SetClipWindow
        add esp, byte 10h
        jmp near RestoreZoneRect+046h
