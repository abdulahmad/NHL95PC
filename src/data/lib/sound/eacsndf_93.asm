; The EACSNDF sound library.
bits 32
%include "hockey.inc"
section s_EDCFC nobits alloc noexec write align=1
global MemViewAttrFlags, SampleTable, SampleTableSize, SongTable, TimbreBanks, PatchFile, MemViewTop
global MemViewCount, MemViewSel, MemViewTitle, MemViewRow, MemViewList, MemViewKey, MemViewFlags, MemViewMode
global MemViewPrevSel
global HuffBitBuffer, HuffBitCount, UnpackSrcPtr, BytePairSrc, UnpackPairState, BytePairDst
global BytePairStack, MemLockHandleStore, __OpenStreams, SndHandleTable
SampleTable:                                    ; Loaded sample records (8 bytes each); used by FindSongSlot,
                                                ; FreeSample, LoadSample ...
        resb 4
SampleTableSize:                                ; Second dword of each sample record; used by SndClearTables
        resb 4
SongTable:                                      ; Song slot records; used by SndClearTables
        resb 304
TimbreBanks:                                    ; Loaded timbre banks; used by AddTimbreBank,
                                                ; LinkPatchTimbres, RemoveTimbreBank ...
        resb 40
PatchFile:                                      ; Loaded patch file; used by GetPatchEntry, GetPatchTimbre,
                                                ; LinkPatchTimbres ...
        resb 4
MemViewTop:                                     ; used by HexDumpRow, MemViewerDrawList, MemViewerSelectRow
        resb 4
MemViewCount:                                   ; used by DumpShapesList, MemViewerDrawList, MemViewerDrawRows
        resb 4
MemViewSel:                                     ; Memory viewer selected row; used by MemViewerDrawRows,
                                                ; MemViewerSelectRow
        resb 4
MemViewTitle:                                   ; used by MemViewerDrawList, MemViewerDrawTitle
        resb 4
MemViewRow:                                     ; used by MemViewerDrawList, MemViewerSelectRow
        resb 4
MemViewList:                                    ; used by DumpMemoryMap, DumpShapesList, MemViewerDrawList ...
        resb 4
MemViewKey:                                     ; Memory viewer last key; used by MemViewerDrawRows,
                                                ; MemViewerSelectRow
        resb 4
MemViewFlags:                                   ; Memory viewer flags; used by MemViewerDrawRows,
                                                ; MemViewerSelectRow
        resb 1
MemViewAttrFlags:                               ; Flags tested by the memory viewer row draw; used by
                                                ; MemViewerDrawRows
        resb 3
MemViewMode:                                    ; used by MemViewerDrawList, MemViewerDrawRows,
                                                ; MemViewerShowArt
        resb 4
MemViewPrevSel:                                 ; Memory viewer previous selection; used by MemViewerDrawRows,
                                                ; MemViewerSelectRow
        resb 4
SndHandleTable:                                 ; copies of the driver table entries for the open sound
                                                ; handles; used by SndDriverCall, SndHandleClose,
                                                ; SndHandleDetect ...
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
HuffBitBuffer:                                  ; Huffman bit buffer; used by HuffGetBits, UnpackHuffman
        resb 4
HuffBitCount:                                   ; Bits left in the Huffman bit buffer; used by HuffGetBits,
                                                ; UnpackHuffman
        resb 4
UnpackSrcPtr:                                   ; Byte pair unpacker source pointer; used by ExpandBytePair,
                                                ; UnpackBytePair, UnpackHuffman
        resb 4
BytePairSrc:                                    ; Byte pair unpack source; used by ExpandBytePair,
                                                ; UnpackBytePair
        resb 4
UnpackPairState:                                ; Byte pair unpacker state; used by HuffGetBits,
                                                ; UnpackBytePair, UnpackHuffman
        resb 4
BytePairDst:                                    ; Byte pair unpack destination; used by ExpandBytePair,
                                                ; UnpackBytePair
        resb 4
BytePairStack:                                  ; Byte pair expansion stack; used by ExpandBytePair,
                                                ; UnpackBytePair
        resb 4
MemLockHandleStore:                             ; Lock handle storage for the memory manager; used by
                                                ; MemLockHandleInit
        resb 4
__OpenStreams:                                  ; List of open stdio streams; used by __InitFiles_,
                                                ; __allocfp_, __freefp_ ...
        resb 4
