; Tables for the sound drivers.
bits 32
%include "hockey.inc"
section s_D5224 progbits alloc noexec write align=1
global str_CULTRASNDMIDI, PcSpkVoiceDefaults, Mpu401Irq, Mpu401IrqMask, WVideoActive, SbEnvDma, SbDmaAlloc, SbDma
global Mpu401DataPort, Mpu401StatusPort, Mpu401RxCount, Mpu401RxMask, Mpu401OldIsr, Mpu401OldIsrSel, GusEnvRead, GusCardFound
global GusDriverIsOpen, GusDigiOpen, GusMusicOpen, GusDriverStreaming, GusPatchFallbacks, GusPatchChannelMask, _environ, ___env_mask
global SbVoiceDefaults, SbEnvErf, SbIrq, GusVoiceDefaults, GusPatchNameMap
PcSpkVoiceDefaults:                             ; Default voice record for the PC speaker driver; used by
                                                ; PcSpkUpdateVoices
        db 010h,00h,00h,00h,07Fh,040h,00h,00h,00h,00h
SbVoiceDefaults:                                ; Default voice record copied by SbInit; used by SbInit
        db 00h,00h,00h,00h,0Fh,00h,0FFh,0FFh,04h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,07Fh,040h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
SbEnvDma:                                       ; DMA channel parsed from the BLASTER variable; used by
                                                ; ParseBlasterEnv, SbOpen
        db 0FFh,0FFh,0FFh,0FFh
SbDmaAlloc:                                     ; Sound Blaster DMA buffer allocation; used by SbClose,
                                                ; SbInit, SbOpen
        db 00h,00h,00h,00h
SbEnvErf:                                       ; Value of the ErF field of the BLASTER variable; used by
                                                ; ParseBlasterEnv
        db 0FFh,0FFh,0FFh,0FFh
SbIrq:                                          ; Sound Blaster interrupt; used by SbOpen
        db 00h,00h,00h,00h
SbDma:                                          ; Sound Blaster DMA channel; used by SbClose, SbOpen
        db 00h,00h,00h,00h
Mpu401DataPort:                                 ; MPU-401 data port (330h); used by Mpu401Command, Mpu401Init,
                                                ; Mpu401Open ...
        db 030h,03h,00h,00h
Mpu401StatusPort:                               ; MPU-401 status and command port (331h); used by
                                                ; Mpu401Command, Mpu401Init, Mpu401Open ...
        db 031h,03h,00h,00h
Mpu401RxCount:                                  ; Cleared by Mpu401Init; used by Mpu401Init
        db 00h,00h,00h,00h
Mpu401RxMask:                                   ; Set to FFh by Mpu401Init; used by Mpu401Init
        db 00h,00h,00h,00h
Mpu401OldIsr:                                   ; Saved interrupt handler offset; non-zero when one is hooked;
                                                ; used by Mpu401Close, Mpu401Init
        db 00h,00h,00h,00h
Mpu401OldIsrSel:                                ; Saved interrupt handler selector; used by Mpu401Close,
                                                ; Mpu401Init
        db 00h,00h,00h,00h,00h
Mpu401Irq:                                      ; MPU-401 IRQ number; used by Mpu401Init, Mpu401Open
        db 07h
Mpu401IrqMask:                                  ; PIC mask bit for the MPU-401 IRQ; used by Mpu401Init,
                                                ; Mpu401Open
        db 080h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,07Fh,040h,00h,00h,00h,00h
GusVoiceDefaults:                               ; Default voice record copied by GusStartup; used by
                                                ; GusStartup
        db 00h,00h,00h,00h,0Fh,00h,0FFh,0FFh,04h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,07Fh,040h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
GusEnvRead:                                     ; Set once the ULTRASND variable has been read; used by
                                                ; GusDetect, GusProbe
        db 00h,00h,00h,00h
GusCardFound:                                   ; Set once the GUS port has been probed; used by
                                                ; GusDriverClose, GusFreeDosBuffer, GusProbe
        db 00h,00h,00h,00h
GusDriverIsOpen:                                ; Set while the GUS driver is open; used by GusDigiMidi,
                                                ; GusDriverClose, GusMusicMidi ...
        db 00h,00h,00h,00h
GusDigiOpen:                                    ; Keeps the GUS driver open while digital sound is in use;
                                                ; used by GusDriverClose
        db 00h,00h,00h,00h
GusMusicOpen:                                   ; Set once GusInitMusic has started the GUS music layer; used
                                                ; by GusCloseMusic, GusDriverClose, GusInitMusic
        db 00h,00h,00h,00h
GusDriverStreaming:                             ; Set while the Gravis driver streams; used by GusCloseDigi,
                                                ; GusDriverClose, GusInitDigi
        db 00h,00h,00h,00h
str_CULTRASNDMIDI:                              ; "C:\ULTRASND\MIDI\" string literal; used by
                                                ; GusLoadMidiPatch, GusStartup
        db 043h,03Ah,05Ch,055h,04Ch,054h,052h,041h,053h,04Eh,044h,05Ch,04Dh,049h,044h,049h
        db 05Ch,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
GusPatchNameMap:                                ; Patch number and file name records (14 bytes each; -1 ends
                                                ; the list); used by GusLoadMidiPatch
        db 0Bh,00h,00h,00h,068h,06Fh,06Dh,065h,06Fh,072h,067h,00h,00h,00h,0FFh,0FFh
        db 0FFh,0FFh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
GusPatchFallbacks:                              ; Pairs of patch numbers: load the second when the first is
                                                ; missing (-1 ends); used by GusLoadMidiPatch
        db 0Dh,00h,00h,00h,0Bh,00h,00h,00h,0Ch,00h,00h,00h,0Bh,00h,00h,00h
        db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
GusPatchChannelMask:                            ; Channel bit mask tested by GusLoadMidiPatch; used by
                                                ; GusLoadMidiPatch
        db 0Fh,00h,00h,00h
WVideoActive:                                   ; Debugger video active; used by __EnterWVIDEO_
        db 00h,00h,00h,00h
_environ:                                       ; Watcom: the environment pointer table __setenvp_ builds;
                                                ; used by __cenvarg_, __setenvp_, getenv_ ...
        db 00h,00h,00h,00h
___env_mask:                                    ; Watcom: one flag byte per environ entry, built by
                                                ; __setenvp_; used by __setenvp_
        db 00h,00h,00h,00h
