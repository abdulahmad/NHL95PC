; The EACSNDF sound library.
bits 32
%include "hockey.inc"
section s_EDCFC nobits alloc noexec write align=1
global byte_EDE7D, dword_EDCFC, dword_EDD00, dword_EDD04, dword_EDE34, dword_EDE5C, MemViewTop
global MemViewCount, MemViewSel, MemViewTitle, MemViewRow, MemViewList, MemViewKey, MemViewFlags, MemViewMode
global MemViewPrevSel
global dword_EDEE0, dword_EDEE4, UnpackSrcPtr, dword_EDEEC, UnpackPairState, dword_EDEF4
global dword_EDEF8, MemLockHandleStore, __OpenStreams, SndHandleTable
dword_EDCFC:
        resb 4
dword_EDD00:
        resb 4
dword_EDD04:
        resb 304
dword_EDE34:
        resb 40
dword_EDE5C:
        resb 4
MemViewTop:
        resb 4
MemViewCount:
        resb 4
MemViewSel:
        resb 4
MemViewTitle:
        resb 4
MemViewRow:
        resb 4
MemViewList:
        resb 4
MemViewKey:
        resb 4
MemViewFlags:
        resb 1
byte_EDE7D:
        resb 3
MemViewMode:
        resb 4
MemViewPrevSel:
        resb 4
SndHandleTable:
        resb 4
        resb 4
        resb 4
        resb 4
        resb 4
        resb 4
        resb 4
        resb 4
        resb 4
        resb 4
        resb 48
dword_EDEE0:
        resb 4
dword_EDEE4:
        resb 4
UnpackSrcPtr:
        resb 4
dword_EDEEC:
        resb 4
UnpackPairState:
        resb 4
dword_EDEF4:
        resb 4
dword_EDEF8:
        resb 4
MemLockHandleStore:
        resb 4
__OpenStreams:
        resb 4
