; Tables for the sound drivers.
bits 32
%include "hockey.inc"
section s_F7978 nobits alloc noexec write align=1
global GusPlayDmaChannel, GusIrqLatch, GusRecordDmaChannel, GusMidiIrq, GusWaveIrq, GusDmaControl, GusVoiceIrqBits, byte_F79E8
global GusDmaLeft, GusDmaChunkSize, GusDmaDone, dword_F79F8, dword_F79FC, dword_F7A00, GusVoiceAllocMask, GusDmaChannels
global GusDosResult, GusIrqFlags, GusActiveVoices, GusCriticalDepth, GusDmaChunkLo, GusDmaChunkHi, GusDmaFlags
GusDmaChannels:
        resb 36
GusDosResult:
        resb 2
GusIrqFlags:
        resb 2
GusActiveVoices:
        resb 2
GusCriticalDepth:
        resb 2
GusPlayDmaChannel:
        resb 1
GusIrqLatch:
        resb 1
GusRecordDmaChannel:
        resb 1
GusMidiIrq:
        resb 1
GusWaveIrq:
        resb 16
GusDmaChunkLo:
        resb 2
GusDmaChunkHi:
        resb 2
GusDmaLeft:
        resb 4
GusDmaChunkSize:
        resb 4
GusDmaDone:
        resb 4
GusDmaControl:
        resb 1
GusDmaFlags:
        resb 15
GusVoiceIrqBits:
        resb 16
byte_F79E8:
        resb 16
dword_F79F8:
        resb 4
dword_F79FC:
        resb 4
dword_F7A00:
        resb 376
GusVoiceAllocMask:
        resb 16
