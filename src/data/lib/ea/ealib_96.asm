; Tables for the EA libraries: the mouse, the clip rectangle, and the file and video state.
bits 32
%include "hockey.inc"
section s_F1704 nobits alloc noexec write align=1
global SeqQueue, SeqQueueData, SeqSysexBuffer, SeqEventNote, SeqEventVelocity, SeqEventLength, SeqEventValue, SeqNextEvent
global SongRecords, SeqEvent
SeqQueue:                                       ; Sequencer command queue (128 bytes); used by SeqFlushQueue,
                                                ; SeqQueueCommand
        resb 1
SeqQueueData:                                   ; Data bytes of the sequencer command queue; used by
                                                ; SeqFlushQueue
        resb 127
SeqSysexBuffer:                                 ; Buffer for system exclusive messages; used by SeqReadEvent,
                                                ; SeqStepTrack
        resb 256
SeqEvent:                                       ; Event record SeqReadEvent fills: delta time first; used by
                                                ; SeqStepTrack
        resb 4
SeqEventValue:                                  ; Event value (controller number or pitch bend); used by
                                                ; SeqStepTrack
        resb 4
SeqEventNote:                                   ; Event status or note byte; used by SeqStepTrack
        resb 1
SeqEventVelocity:                               ; Event velocity or data byte; used by SeqStepTrack
        resb 1
SeqEventLength:                                 ; Event length in bytes; used by SeqStepTrack
        resb 2
SeqNextEvent:                                   ; Record for the delta time of the next event; used by
                                                ; SeqStepTrack
        resb 12
SongRecords:                                    ; Song records (12 bytes): song pointer first; used by
                                                ; ReleaseAllVoices, SeqNoteOn, SeqStepTrack ...
        resb 8
