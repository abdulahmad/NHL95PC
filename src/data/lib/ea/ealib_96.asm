; Tables for the EA libraries: the mouse, the clip rectangle, and the file and video state.
bits 32
%include "hockey.inc"
section s_F1704 nobits alloc noexec write align=1
global SeqQueue, SeqQueueData, SeqSysexBuffer, SeqEventNote, SeqEventVelocity, SeqEventLength, SeqEventValue, SeqNextEvent
global SongRecords, SeqEvent
SeqQueue:
        resb 1
SeqQueueData:
        resb 127
SeqSysexBuffer:
        resb 256
SeqEvent:
        resb 4
SeqEventValue:
        resb 4
SeqEventNote:
        resb 1
SeqEventVelocity:
        resb 1
SeqEventLength:
        resb 2
SeqNextEvent:
        resb 12
SongRecords:
        resb 8
