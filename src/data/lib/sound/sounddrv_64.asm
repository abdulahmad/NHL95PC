; Tables for the sound drivers.
bits 32
%include "hockey.inc"
section s_D5224 progbits alloc noexec write align=1
global str_CULTRASNDMIDI, PcSpkVoiceDefaults, Mpu401Irq, Mpu401IrqMask, WVideoActive, SbEnvDma, SbDmaAlloc, SbDma
global Mpu401DataPort, Mpu401StatusPort, Mpu401RxCount, Mpu401RxMask, Mpu401OldIsr, Mpu401OldIsrSel, GusEnvRead, GusCardFound
global GusDriverIsOpen, GusDigiOpen, GusMusicOpen, GusDriverStreaming, GusPatchFallbacks, GusPatchChannelMask, _environ, ___env_mask
global SbVoiceDefaults, SbEnvErf, SbIrq, GusVoiceDefaults, GusPatchNameMap
PcSpkVoiceDefaults:
        db 010h,00h,00h,00h,07Fh,040h,00h,00h,00h,00h
SbVoiceDefaults:
        db 00h,00h,00h,00h,0Fh,00h,0FFh,0FFh,04h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,07Fh,040h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
SbEnvDma:
        db 0FFh,0FFh,0FFh,0FFh
SbDmaAlloc:
        db 00h,00h,00h,00h
SbEnvErf:
        db 0FFh,0FFh,0FFh,0FFh
SbIrq:
        db 00h,00h,00h,00h
SbDma:
        db 00h,00h,00h,00h
Mpu401DataPort:
        db 030h,03h,00h,00h
Mpu401StatusPort:
        db 031h,03h,00h,00h
Mpu401RxCount:
        db 00h,00h,00h,00h
Mpu401RxMask:
        db 00h,00h,00h,00h
Mpu401OldIsr:
        db 00h,00h,00h,00h
Mpu401OldIsrSel:
        db 00h,00h,00h,00h,00h
Mpu401Irq:
        db 07h
Mpu401IrqMask:
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
GusVoiceDefaults:
        db 00h,00h,00h,00h,0Fh,00h,0FFh,0FFh,04h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,07Fh,040h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
GusEnvRead:
        db 00h,00h,00h,00h
GusCardFound:
        db 00h,00h,00h,00h
GusDriverIsOpen:
        db 00h,00h,00h,00h
GusDigiOpen:
        db 00h,00h,00h,00h
GusMusicOpen:
        db 00h,00h,00h,00h
GusDriverStreaming:
        db 00h,00h,00h,00h
str_CULTRASNDMIDI:
        db 043h,03Ah,05Ch,055h,04Ch,054h,052h,041h,053h,04Eh,044h,05Ch,04Dh,049h,044h,049h
        db 05Ch,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
GusPatchNameMap:
        db 0Bh,00h,00h,00h,068h,06Fh,06Dh,065h,06Fh,072h,067h,00h,00h,00h,0FFh,0FFh
        db 0FFh,0FFh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
GusPatchFallbacks:
        db 0Dh,00h,00h,00h,0Bh,00h,00h,00h,0Ch,00h,00h,00h,0Bh,00h,00h,00h
        db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
GusPatchChannelMask:
        db 0Fh,00h,00h,00h
WVideoActive:
        db 00h,00h,00h,00h
_environ:
        db 00h,00h,00h,00h
___env_mask:
        db 00h,00h,00h,00h
