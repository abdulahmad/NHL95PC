; The EACSNDF sound library.
bits 32
%include "hockey.inc"
section s_EDCFC nobits alloc noexec write align=1
global MemViewAttrFlags, SampleTable, SampleTableSize, SongTable, TimbreBanks, PatchFile, MemViewTop
global MemViewCount, MemViewSel, MemViewTitle, MemViewRow, MemViewList, MemViewKey, MemViewFlags, MemViewMode
global MemViewPrevSel
global HuffBitBuffer, HuffBitCount, UnpackSrcPtr, BytePairSrc, UnpackPairState, BytePairDst
global BytePairStack, MemLockHandleStore, __OpenStreams, SndHandleTable
SampleTable:
        resb 4
SampleTableSize:
        resb 4
SongTable:
        resb 304
TimbreBanks:
        resb 40
PatchFile:
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
MemViewAttrFlags:
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
HuffBitBuffer:
        resb 4
HuffBitCount:
        resb 4
UnpackSrcPtr:
        resb 4
BytePairSrc:
        resb 4
UnpackPairState:
        resb 4
BytePairDst:
        resb 4
BytePairStack:
        resb 4
MemLockHandleStore:
        resb 4
__OpenStreams:
        resb 4
