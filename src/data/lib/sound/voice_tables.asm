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
PcSpkVoices:                                    ; PC speaker MIDI voice and channel records; used by
                                                ; PcSpkInit, PcSpkNoteOff, PcSpkNoteOn ...
        resb 1
        resb 767
        resb 22
        resb 1
        resb 7
        resb 7
        resb 1835
AdlibVoices:                                    ; AdLib MIDI voice and channel records; used by
                                                ; AdlibController, AdlibInit, AdlibNoteOff ...
        resb 20
        resb 2
        resb 2
        resb 2
        resb 1
        resb 1
        resb 452
AdlibChanState:                                 ; AdLib per-channel state; used by AdlibController, AdlibInit,
                                                ; AdlibNoteOff ...
        resb 64
        resb 8
        resb 70
        resb 1
        resb 695
        resb 2
        resb 2
        resb 2
SbMidiVoices:                                   ; Sound Blaster MIDI voice and channel records; used by
                                                ; SbController, SbFreeVoice, SbInit ...
        resb 2
SbVoiceRate:                                    ; Rate per Sound Blaster voice; used by SbInit
        resb 6
SbChanVolume:                                   ; Volume per Sound Blaster MIDI channel; used by SbController
        resb 6
SbVoiceSample:                                  ; Sample per Sound Blaster voice; used by SbInit
        resb 122
        resb 88
SbChanRecords:                                  ; Sound Blaster per-channel records; used by SbController,
                                                ; SbInit, SbNoteOff ...
        resb 4
SbChanTrack:                                    ; Track per Sound Blaster MIDI channel; used by SbSetTrack
        resb 18
SbChanBend:                                     ; Pitch bend per Sound Blaster MIDI channel; used by
                                                ; SbPitchBend
        resb 458
        resb 2
        resb 2
        resb 4
GusPatchState:                                  ; GUS driver voice, channel and patch records; used by
                                                ; GusAllocDosBuffer, GusController, GusDetect ...
        resb 2
        resb 7166
        resb 2
GusDriverBasePort:                              ; Base port of the Gravis card; used by GusDetect, GusProbe
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
CMainArgc:                                      ; Argument count passed to main; used by __CMain
        resb 4
CMainArgv:                                      ; Argument vector passed to main; used by __CMain
        resb 4
RationalAllocLimit:                             ; used by RationalAlloc_
        resb 2
RationalAllocFlags:                             ; used by RationalAlloc_
        resb 2
Hook387Save:                                    ; used by __hook387
        resb 148
GusMidiVoices:                                  ; GUS MIDI layer voice and channel records; used by
                                                ; GusForgetPatch, GusMidiInit, GusMidiNoteOff ...
        resb 1
GusMidiVoiceNote:                               ; Note per GUS MIDI voice; used by GusMidiNoteOff,
                                                ; GusMidiNoteOn, GusSetSustain ...
        resb 1
GusMidiVoiceVelocity:                           ; Velocity per GUS MIDI voice; used by GusMidiNoteOff,
                                                ; GusMidiNoteOn, GusSetSustain
        resb 126
        resb 1
        resb 1
        resb 2
        resb 4
        resb 1
        resb 3
        resb 500
GusWaveVoices:                                  ; GUS wave voice records (33 bytes per voice); used by
                                                ; GusChannelNotesOff, GusMidiInit, GusMidiNoteOff ...
        resb 19
GusWaveVoiceFlags:                              ; Flags byte of each GUS wave voice record (bit 0 set while
                                                ; the voice plays); used by GusStopNoteVoices
        resb 1035
        resb 2
        resb 254
        resb 2
        resb 2
        resb 14
GusDramSize:                                    ; Gravis on-board memory size; used by GusDramAlloc,
                                                ; GusDramFreeTotal, GusDramLargestFree ...
        resb 4
GusEnvConfig:                                   ; ULTRASND environment settings; used by GusGetEnvConfig
        resb 12
