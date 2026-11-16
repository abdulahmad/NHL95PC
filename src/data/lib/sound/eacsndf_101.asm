; The EACSNDF sound library.
bits 32
%include "hockey.inc"
section s_F23BC nobits alloc noexec write align=1
global MidiChannelUsed, MusicBankHeader, MusicBankPatchNum, MusicBankTimbreCount, MusicBankTimbreNums, SndHandleType, __HeapFlags, __nheap_clean
global MusicPatchFile, MusicTimbreFiles, MusicTimbreSizes, AtexitRoutines, AtexitTable, SpeechBankCount, __ClosedStreams, delaycount
global _doserrno, ErrnoVar
MidiChannelUsed:
        resb 16
MusicBankHeader:
        resb 1
MusicBankPatchNum:
        resb 2
MusicBankTimbreCount:
        resb 17
MusicBankTimbreNums:
        resb 10
MusicPatchFile:
        resb 4
MusicTimbreFiles:
        resb 40
MusicTimbreSizes:
        resb 38
AtexitRoutines:
        resb 2
SndHandleType:
        resb 2
AtexitTable:
        resb 128
SpeechBankCount:
        resb 4
__HeapFlags:
        resb 1
__nheap_clean:
        resb 3
__ClosedStreams:
        resb 4
delaycount:
        resb 4
_doserrno:
        resb 4
ErrnoVar:
        resb 4
