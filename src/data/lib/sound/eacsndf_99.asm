; The EACSNDF sound library.
bits 32
%include "hockey.inc"
section s_F22FC nobits alloc noexec write align=1
global DigiFadeLevel, DigiFadeAccum, DigiFadeStep, DigiFadeChannel, DigiFadeDriver
DigiFadeLevel:                                  ; Current level of each digital channel fade (20-byte
                                                ; records); used by PlayDigiBlock, PlayDigiBlockLoop,
                                                ; PlayDigiPtr ...
        resb 4
DigiFadeAccum:                                  ; Fixed-point level of each digital channel fade; used by
                                                ; SetDigiChannelVolume
        resb 4
DigiFadeStep:                                   ; Step per tick of each digital channel fade; used by
                                                ; SetDigiChannelVolume
        resb 4
DigiFadeChannel:                                ; Channel of each digital channel fade; used by
                                                ; SetDigiChannelVolume
        resb 4
DigiFadeDriver:                                 ; Driver of each digital channel fade; used by
                                                ; SetDigiChannelVolume
        resb 65
