; Tables for the EA libraries: the mouse, the clip rectangle, and the file and video state.
bits 32
%include "hockey.inc"
section s_EDAA8 nobits alloc noexec write align=1
global vesamodeok, MemDescriptorBase, MemDescriptorTop
global MemLockHandle, MemFreeBytes, vesapresent, ScreenWidthPtr, timercallbacks, vesamodeinfo, vesainfo
MemDescriptorBase:
        resb 4
MemDescriptorTop:
        resb 4
MemLockHandle:
        resb 4
MemFreeBytes:
        resb 4
vesamodeinfo:
        resb 2
        resb 1
        resb 253
vesainfo:
        resb 18
        resb 238
vesapresent:
        resb 4
ScreenWidthPtr:
        resb 4
vesamodeok:
        resb 1
        resb 2
        resb 2
        resb 2
        resb 21
timercallbacks:
        resb 32
