; The EACSNDF sound library.
bits 32
%include "hockey.inc"
section s_F23BC nobits alloc noexec write align=1
global byte_F23BC, byte_F23CC, byte_F23CD, byte_F23CF, byte_F23E0, SndHandleType, __HeapFlags, __nheap_clean
global dword_F23EA, dword_F23EE, dword_F2416, dword_F243C, AtexitTable, SpeechBankCount, __ClosedStreams, delaycount
global _doserrno, ErrnoVar
byte_F23BC:
        resb 16
byte_F23CC:
        resb 1
byte_F23CD:
        resb 2
byte_F23CF:
        resb 17
byte_F23E0:
        resb 10
dword_F23EA:
        resb 4
dword_F23EE:
        resb 40
dword_F2416:
        resb 38
dword_F243C:
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
