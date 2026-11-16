; Tables for the sound drivers.
bits 32
%include "hockey.inc"
section s_F7978 nobits alloc noexec write align=1
global GusPlayDmaChannel, GusIrqLatch, GusRecordDmaChannel, GusMidiIrq, GusWaveIrq, byte_F79C8, GusVoiceIrqBits, byte_F79E8
global dword_F79BC, dword_F79C0, dword_F79C4, dword_F79F8, dword_F79FC, dword_F7A00, GusVoiceAllocMask, GusDmaChannels
global GusDosResult, GusIrqFlags, GusActiveVoices, GusCriticalDepth, word_F79B8, word_F79BA, word_F79C9
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
word_F79B8:
        resb 2
word_F79BA:
        resb 2
dword_F79BC:
        resb 4
dword_F79C0:
        resb 4
dword_F79C4:
        resb 4
byte_F79C8:
        resb 1
word_F79C9:
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
