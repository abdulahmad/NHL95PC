; Tables for the sound drivers.
bits 32
%include "hockey.inc"
section s_F7978 nobits alloc noexec write align=1
global GusPlayDmaChannel, GusIrqLatch, GusRecordDmaChannel, GusMidiIrq, GusWaveIrq, GusDmaControl, GusVoiceIrqBits, GusTimerState
global GusDmaLeft, GusDmaChunkSize, GusDmaDone, GusVoicePrioLo, GusVoicePrioHi, GusVoiceStealFn, GusVoiceAllocMask, GusDmaChannels
global GusDosResult, GusIrqFlags, GusActiveVoices, GusCriticalDepth, GusDmaChunkLo, GusDmaChunkHi, GusDmaFlags
GusDmaChannels:                                 ; used by GusDmaCount, GusMaskDma, GusProgramDma ...
        resb 36
GusDosResult:                                   ; Result of the last DOS file call; used by GusDosClose,
                                                ; GusDosOpen, GusDosRead ...
        resb 2
GusIrqFlags:                                    ; used by GusClose, GusDownload, GusDramDmaDone ...
        resb 2
GusActiveVoices:                                ; used by GusAllocVoice, GusCalcVoiceAddrs, GusChannelNotesOff
                                                ; ...
        resb 2
GusCriticalDepth:                               ; used by GusClearIrqState, GusEnterCritical, GusLeaveCritical
                                                ; ...
        resb 2
GusPlayDmaChannel:                              ; used by GusDownload, GusInitDma, GusOpenCard ...
        resb 1
GusIrqLatch:                                    ; used by GusOpen, GusSetIrqDmaLatches
        resb 1
GusRecordDmaChannel:                            ; used by GusInitDma, GusOpenCard, GusSetIrqDmaLatches ...
        resb 1
GusMidiIrq:                                     ; used by GusClose, GusMidiIrqHandler, GusOpenCard ...
        resb 1
GusWaveIrq:                                     ; used by GusClose, GusOpenCard, GusReadIrqSource ...
        resb 16
GusDmaChunkLo:                                  ; Low word of the current DMA chunk's card address; used by
                                                ; GusDmaNextChunk, GusStartDramDma
        resb 2
GusDmaChunkHi:                                  ; High word of the current DMA chunk's card address; used by
                                                ; GusDmaNextChunk, GusStartDramDma
        resb 2
GusDmaLeft:                                     ; Bytes of the download still to transfer; used by
                                                ; GusDmaNextChunk, GusStartDramDma
        resb 4
GusDmaChunkSize:                                ; Size of the current DMA chunk; used by GusDmaNextChunk,
                                                ; GusStartDramDma
        resb 4
GusDmaDone:                                     ; Bytes of the download transferred so far; used by
                                                ; GusDmaNextChunk, GusStartDramDma
        resb 4
GusDmaControl:                                  ; DMA control register value for the download; used by
                                                ; GusDmaNextChunk, GusStartDramDma, GusStopDma
        resb 1
GusDmaFlags:                                    ; Flags of the current download; used by GusStartDramDma
        resb 15
GusVoiceIrqBits:                                ; used by GusClearCallbacks, GusResetTimers, GusServiceIrq ...
        resb 16
GusTimerState:                                  ; Shadow of the GUS timer control register; used by
                                                ; GusResetTimers, GusStartTimer1, GusStartTimer2 ...
        resb 16
GusVoicePrioLo:                                 ; Low dword of each voice's steal priority (12-byte records);
                                                ; used by GusAllocVoice, GusResetVoiceAlloc
        resb 4
GusVoicePrioHi:                                 ; High dword of each voice's steal priority; used by
                                                ; GusAddVoicePriority, GusAllocVoice, GusResetVoiceAlloc
        resb 4
GusVoiceStealFn:                                ; Routine called when a voice is stolen; used by GusAllocVoice
        resb 376
GusVoiceAllocMask:                              ; Bit mask of voices in use; used by GusAllocVoice,
                                                ; GusReleaseVoice, GusResetVoiceAlloc
        resb 16
