; Tables for the sound drivers.
bits 32
%include "hockey.inc"
section s_F24D8 nobits alloc noexec write align=1
global GusMidiVoices, GusMidiVoiceNote, GusMidiVoiceVelocity
global GusWaveVoiceFlags, AdlibVoices, AdlibChanState, SbVoiceSample
global CMainArgc, CMainArgv, RationalAllocLimit
global GusEnvConfig, PcSpkVoices, SbChanRecords, Hook387Save
global GusWaveVoices
global SbMidiVoices, SbVoiceRate, SbChanVolume, SbChanTrack, SbChanBend
global GusPatchState, GusDriverBasePort
global RationalAllocFlags
global GusDramSize
PcSpkVoices:
        resb 1
        resb 767
        resb 22
        resb 1
        resb 7
        resb 7
        resb 1835
AdlibVoices:
        resb 20
        resb 2
        resb 2
        resb 2
        resb 1
        resb 1
        resb 452
AdlibChanState:
        resb 64
        resb 8
        resb 70
        resb 1
        resb 695
        resb 2
        resb 2
        resb 2
SbMidiVoices:
        resb 2
SbVoiceRate:
        resb 6
SbChanVolume:
        resb 6
SbVoiceSample:
        resb 122
        resb 88
SbChanRecords:
        resb 4
SbChanTrack:
        resb 18
SbChanBend:
        resb 458
        resb 2
        resb 2
        resb 4
GusPatchState:
        resb 2
        resb 7166
        resb 2
GusDriverBasePort:
        resb 2
        resb 1
        resb 3
        resb 2
        resb 4
        resb 8
        resb 122
        resb 4
        resb 18
        resb 458
        resb 88
        resb 4
        resb 4
        resb 4
        resb 4
        resb 4
        resb 728
        resb 2
        resb 2
        resb 2
        resb 2
CMainArgc:
        resb 4
CMainArgv:
        resb 4
RationalAllocLimit:
        resb 2
RationalAllocFlags:
        resb 2
Hook387Save:
        resb 148
GusMidiVoices:
        resb 1
GusMidiVoiceNote:
        resb 1
GusMidiVoiceVelocity:
        resb 126
        resb 1
        resb 1
        resb 2
        resb 4
        resb 1
        resb 3
        resb 500
GusWaveVoices:
        resb 19
GusWaveVoiceFlags:
        resb 1035
        resb 2
        resb 254
        resb 2
        resb 2
        resb 14
GusDramSize:
        resb 4
GusEnvConfig:
        resb 12
