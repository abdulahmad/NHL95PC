; Tables for the sound drivers.
bits 32
%include "hockey.inc"
section s_D71F0 progbits alloc noexec write align=1
extern SbStreamChannels, str_ULTRASND
global SbDmaRunning, SbMixPaused, SbSignTable, GusIrqLatchBits, GusVolumeCurve, GusMidiReady
global GusStreamVoiceLeft, GusStreamVoiceRight, GusDmaPageTable, GusDmaLatchBits, GusMidiInitFlag, GusDramSized
global SbMixSrcPos, SbMixStep, SbMixSrcEnd, SbMixCount, SbMixReadPos, SbDmaHalfSize, SbDmaBuffer, GusOpenCount
global GusPitchTable, GusStreamActive, GusStreamLeftBuf, GusStreamLeftPending, GusStreamBusyLeft, GusStreamRightBuf, GusStreamRightPending, GusStreamBusyRight
global GusStreamChannels
global GusStreamBufSize, GusStreamHalfSize, GusStreamQuarterSize, GusStreamBufShift, GusStreamHalfShift, GusStreamQuarterLog2, GusFillCount, GusStreamState
global GusFillScratch, GusFillDest, GusStreamCardLeft, GusStreamCardRight, GusStreamCardEnd, GusStreamStartLo, GusStreamEndLo, GusEnvVarName
global GusChanBendRange, GusChanBendCents, GusChanRpnMsb, GusChanRpnLsb, GusChanVolume, GusChanExpression, ExecParamBlock
global SpawnSavedEsp, BlitColumnOffsets, BlitSourcePtr, DmaDefaultMode
global GusIrqOldHandler, GusDmaBusy, GusMidiPending, GusMidiIrqCount, GusTimerCallback, GusDmaDoneCallback, GusRecordDoneCallback, GusWaveCallback
global GusVolumeCallback, GusTimer1Callback, GusTimer2Callback, GusWaveIrqCallback, GusVolumeIrqCallback, GusMidiXmitCallback, GusMidiRecvCallback, GusNoteFreqTable
global GusNoteFreqUpper, GusFreqDivisor, GusVoiceAllocAge, SbStreamTable, GusStreamTable, SbMixBuffer
global MixVolumeTable, GusStreamStepsChan0, GusStreamStepsChan1
global GusStreamStepsChan2, GusStreamStepsChan3, GusStreamLoopLo, GusStreamLoopHi, GusStreamStartHi, GusStreamEndHi
global SpawnSavedSs, SpawnSavedDs, GusIrqVectorTable, GusIrqOldSelector, GusBasePort, GusIrqStatusPort
global GusTimer1Count, GusTimer2Count, GusIrqLatchPort, GusDmaLatchPort, GusMidiControlPort, GusMidiDataPort, GusVoiceSelectPort, GusRegSelectPort
global GusDataLowPort, GusDataHighPort, GusDramPort, GusIrqPending
SbStreamTable:                                  ; Sound Blaster stream records by channel; used by
                                                ; SbMixerOpen, SbStreamApplyBend, SbStreamGetVolume ...
        dd SbStreamChannels
        dd SbStreamChannels+0144h
        dd SbStreamChannels+0288h
        dd SbStreamChannels+03CCh
SbMixSrcPos:                                    ; Mixer source position; used by SbMixChannels
        db 00h,00h,00h,00h
SbMixStep:                                      ; Mixer source step; used by SbMixChannels
        db 00h,00h,00h,00h
SbMixSrcEnd:                                    ; Mixer source end; used by SbMixChannels
        db 00h,00h,00h,00h
SbMixCount:                                     ; Samples left to mix; used by SbMixChannels
        db 00h,00h,00h,00h,014h,00h,00h,00h
SbMixBuffer:                                    ; Sound Blaster mix accumulator of 16-bit words; used by
                                                ; SbMixAdd8, SbMixAdd8Vol, SbMixChannels
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
        db 00h,00h
MixVolumeTable:                                 ; Volume scaling table shared by the mixers; used by
                                                ; GusFillStreamBuffer, GusStreamStart, SbMixChannels ...
        db 0DEh,0DEh,0EBh,0DEh,0F3h,0DEh,0F8h,0DEh,0FBh,0DEh,0FDh,0DEh,0FEh,0DEh,0FFh,0DEh
        db 01h,0DEh,02h,0DEh,03h,0DEh,05h,0DEh,08h,0DEh,0Dh,0DEh,015h,0DEh,022h,0DEh
        db 0DEh,0EBh,0EBh,0EBh,0F3h,0EBh,0F8h,0EBh,0FBh,0EBh,0FDh,0EBh,0FEh,0EBh,0FFh,0EBh
        db 01h,0EBh,02h,0EBh,03h,0EBh,05h,0EBh,08h,0EBh,0Dh,0EBh,015h,0EBh,022h,0EBh
        db 0DEh,0F3h,0EBh,0F3h,0F3h,0F3h,0F8h,0F3h,0FBh,0F3h,0FDh,0F3h,0FEh,0F3h,0FFh,0F3h
        db 01h,0F3h,02h,0F3h,03h,0F3h,05h,0F3h,08h,0F3h,0Dh,0F3h,015h,0F3h,022h,0F3h
        db 0DEh,0F8h,0EBh,0F8h,0F3h,0F8h,0F8h,0F8h,0FBh,0F8h,0FDh,0F8h,0FEh,0F8h,0FFh,0F8h
        db 01h,0F8h,02h,0F8h,03h,0F8h,05h,0F8h,08h,0F8h,0Dh,0F8h,015h,0F8h,022h,0F8h
        db 0DEh,0FBh,0EBh,0FBh,0F3h,0FBh,0F8h,0FBh,0FBh,0FBh,0FDh,0FBh,0FEh,0FBh,0FFh,0FBh
        db 01h,0FBh,02h,0FBh,03h,0FBh,05h,0FBh,08h,0FBh,0Dh,0FBh,015h,0FBh,022h,0FBh
        db 0DEh,0FDh,0EBh,0FDh,0F3h,0FDh,0F8h,0FDh,0FBh,0FDh,0FDh,0FDh,0FEh,0FDh,0FFh,0FDh
        db 01h,0FDh,02h,0FDh,03h,0FDh,05h,0FDh,08h,0FDh,0Dh,0FDh,015h,0FDh,022h,0FDh
        db 0DEh,0FEh,0EBh,0FEh,0F3h,0FEh,0F8h,0FEh,0FBh,0FEh,0FDh,0FEh,0FEh,0FEh,0FFh,0FEh
        db 01h,0FEh,02h,0FEh,03h,0FEh,05h,0FEh,08h,0FEh,0Dh,0FEh,015h,0FEh,022h,0FEh
        db 0DEh,0FFh,0EBh,0FFh,0F3h,0FFh,0F8h,0FFh,0FBh,0FFh,0FDh,0FFh,0FEh,0FFh,0FFh,0FFh
        db 01h,0FFh,02h,0FFh,03h,0FFh,05h,0FFh,08h,0FFh,0Dh,0FFh,015h,0FFh,022h,0FFh
        db 0DEh,01h,0EBh,01h,0F3h,01h,0F8h,01h,0FBh,01h,0FDh,01h,0FEh,01h,0FFh,01h
        db 01h,01h,02h,01h,03h,01h,05h,01h,08h,01h,0Dh,01h,015h,01h,022h,01h
        db 0DEh,02h,0EBh,02h,0F3h,02h,0F8h,02h,0FBh,02h,0FDh,02h,0FEh,02h,0FFh,02h
        db 01h,02h,02h,02h,03h,02h,05h,02h,08h,02h,0Dh,02h,015h,02h,022h,02h
        db 0DEh,03h,0EBh,03h,0F3h,03h,0F8h,03h,0FBh,03h,0FDh,03h,0FEh,03h,0FFh,03h
        db 01h,03h,02h,03h,03h,03h,05h,03h,08h,03h,0Dh,03h,015h,03h,022h,03h
        db 0DEh,05h,0EBh,05h,0F3h,05h,0F8h,05h,0FBh,05h,0FDh,05h,0FEh,05h,0FFh,05h
        db 01h,05h,02h,05h,03h,05h,05h,05h,08h,05h,0Dh,05h,015h,05h,022h,05h
        db 0DEh,08h,0EBh,08h,0F3h,08h,0F8h,08h,0FBh,08h,0FDh,08h,0FEh,08h,0FFh,08h
        db 01h,08h,02h,08h,03h,08h,05h,08h,08h,08h,0Dh,08h,015h,08h,022h,08h
        db 0DEh,0Dh,0EBh,0Dh,0F3h,0Dh,0F8h,0Dh,0FBh,0Dh,0FDh,0Dh,0FEh,0Dh,0FFh,0Dh
        db 01h,0Dh,02h,0Dh,03h,0Dh,05h,0Dh,08h,0Dh,0Dh,0Dh,015h,0Dh,022h,0Dh
        db 0DEh,015h,0EBh,015h,0F3h,015h,0F8h,015h,0FBh,015h,0FDh,015h,0FEh,015h,0FFh,015h
        db 01h,015h,02h,015h,03h,015h,05h,015h,08h,015h,0Dh,015h,015h,015h,022h,015h
        db 0DEh,022h,0EBh,022h,0F3h,022h,0F8h,022h,0FBh,022h,0FDh,022h,0FEh,022h,0FFh,022h
        db 01h,022h,02h,022h,03h,022h,05h,022h,08h,022h,0Dh,022h,015h,022h,022h,022h
SbMixReadPos:                                   ; Read position in the mix buffer for the DMA convert; used by
                                                ; SbConvertMix, SbDmaHalfReady
        db 00h,00h,00h,00h
SbDmaRunning:                                   ; Set while Sound Blaster DMA runs; used by SbDmaStart,
                                                ; SbDmaStop
        db 00h
SbMixPaused:                                    ; Set while the mixer is paused; used by SbMixPause
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
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,01h,02h,03h,04h,05h,06h,07h,08h,09h,0Ah,0Bh,0Ch
        db 0Dh,0Eh,0Fh,010h,011h,012h,013h,014h,015h,016h,017h,018h,019h,01Ah,01Bh,01Ch
        db 01Dh,01Eh,01Fh,020h,021h,022h,023h,024h,025h,026h,027h,028h,029h,02Ah,02Bh,02Ch
        db 02Dh,02Eh,02Fh,030h,031h,032h,033h,034h,035h,036h,037h,038h,039h,03Ah,03Bh,03Ch
        db 03Dh,03Eh,03Fh,040h,041h,042h,043h,044h,045h,046h,047h,048h,049h,04Ah,04Bh,04Ch
        db 04Dh,04Eh,04Fh,050h,051h,052h,053h,054h,055h,056h,057h,058h,059h,05Ah,05Bh,05Ch
        db 05Dh,05Eh,05Fh,060h,061h,062h,063h,064h,065h,066h,067h,068h,069h,06Ah,06Bh,06Ch
        db 06Dh,06Eh,06Fh,070h,071h,072h,073h,074h,075h,076h,077h,078h,079h,07Ah,07Bh,07Ch
        db 07Dh,07Eh,07Fh
SbSignTable:                                    ; Clipped 16-bit sum to unsigned 8-bit sample table; used by
                                                ; SbConvertMix
        db 080h,081h,082h,083h,084h,085h,086h,087h,088h,089h,08Ah,08Bh,08Ch,08Dh,08Eh,08Fh
        db 090h,091h,092h,093h,094h,095h,096h,097h,098h,099h,09Ah,09Bh,09Ch,09Dh,09Eh,09Fh
        db 0A0h,0A1h,0A2h,0A3h,0A4h,0A5h,0A6h,0A7h,0A8h,0A9h,0AAh,0ABh,0ACh,0ADh,0AEh,0AFh
        db 0B0h,0B1h,0B2h,0B3h,0B4h,0B5h,0B6h,0B7h,0B8h,0B9h,0BAh,0BBh,0BCh,0BDh,0BEh,0BFh
        db 0C0h,0C1h,0C2h,0C3h,0C4h,0C5h,0C6h,0C7h,0C8h,0C9h,0CAh,0CBh,0CCh,0CDh,0CEh,0CFh
        db 0D0h,0D1h,0D2h,0D3h,0D4h,0D5h,0D6h,0D7h,0D8h,0D9h,0DAh,0DBh,0DCh,0DDh,0DEh,0DFh
        db 0E0h,0E1h,0E2h,0E3h,0E4h,0E5h,0E6h,0E7h,0E8h,0E9h,0EAh,0EBh,0ECh,0EDh,0EEh,0EFh
        db 0F0h,0F1h,0F2h,0F3h,0F4h,0F5h,0F6h,0F7h,0F8h,0F9h,0FAh,0FBh,0FCh,0FDh,0FEh,0FFh
        db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
        db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
        db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
        db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
        db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
        db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
        db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
        db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
        db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
        db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
        db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
        db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
        db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
        db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
        db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
        db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
        db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
        db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
        db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
        db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
        db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
        db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
        db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
        db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
        db 00h,00h
SbDmaHalfSize:                                  ; Half the Sound Blaster DMA buffer size; used by
                                                ; SbConvertMix, SbDmaHalfReady, SbDmaStart
        db 00h,00h,00h,00h
SbDmaBuffer:                                    ; Sound Blaster DMA buffer; used by SbConvertMix, SbDmaStart
        db 00h,00h,00h,00h,00h,00h
GusOpenCount:                                   ; used by GusClose, GusOpen
        db 00h,00h,00h,00h
GusIrqLatchBits:                                ; used by GusOpenCard, GusSetIrqDmaLatches
        db 00h,00h,01h,03h,00h,02h,00h,04h,00h,00h,00h,05h,06h,00h,00h,07h
GusVolumeCurve:                                 ; MIDI velocity and volume to GUS log volume; used by
                                                ; GusMidiNoteOn, GusVoiceUpdateVolume
        db 00h,081h,091h,09Bh,0A1h,0A6h,0ABh,0AEh,0B1h,0B4h,0B6h,0B9h,0BBh,0BCh,0BEh,0C0h
        db 0C1h,0C3h,0C4h,0C5h,0C6h,0C7h,0C9h,0CAh,0CBh,0CBh,0CCh,0CDh,0CEh,0CFh,0D0h,0D0h
        db 0D1h,0D2h,0D3h,0D3h,0D4h,0D5h,0D5h,0D6h,0D6h,0D7h,0D7h,0D8h,0D9h,0D9h,0DAh,0DAh
        db 0DBh,0DBh,0DBh,0DCh,0DCh,0DDh,0DDh,0DEh,0DEh,0DEh,0DFh,0DFh,0E0h,0E0h,0E0h,0E1h
        db 0E1h,0E2h,0E3h,0E4h,0E5h,0E6h,0E7h,0E7h,0E8h,0E9h,0EAh,0EAh,0EBh,0ECh,0ECh,0EDh
        db 0EEh,0EEh,0EFh,0EFh,0F0h,0F1h,0F1h,0F2h,0F2h,0F3h,0F3h,0F4h,0F4h,0F4h,0F5h,0F5h
        db 0F6h,0F6h,0F7h,0F7h,0F7h,0F8h,0F8h,0F9h,0F9h,0F9h,0FAh,0FAh,0FAh,0FBh,0FBh,0FBh
        db 0FCh,0FCh,0FCh,0FDh,0FDh,0FDh,0FEh,0FEh,0FEh,0FEh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
GusPitchTable:                                  ; Pitch multipliers for bend and vibrato; used by
                                                ; GusMidiPitchBend, GusVoiceSetVibrato
        db 00h,04h,00h,00h,03Dh,04h,00h,00h,07Dh,04h,00h,00h,0C2h,04h,00h,00h
        db 0Ah,05h,00h,00h,057h,05h,00h,00h,0A8h,05h,00h,00h,0FEh,05h,00h,00h
        db 059h,06h,00h,00h,0BAh,06h,00h,00h,021h,07h,00h,00h,08Dh,07h,00h,00h
GusMidiReady:                                   ; Set once the GUS MIDI layer is set up; used by GusMidiInit,
                                                ; GusMidiNoteOn, GusVoiceUpdateVolume
        db 01h,00h,00h,00h
GusStreamActive:                                ; Set while the stream voices are running; used by
                                                ; GusStartStream, GusStopStream, GusStreamVoiceIrq
        db 00h,00h,00h,00h
GusStreamLeftBuf:                               ; Host buffer for the left stream half; used by
                                                ; GusFillStreamBuffer, GusStartStream
        db 00h,00h,00h,00h
GusStreamLeftPending:                           ; Left half waits for refill; used by GusFillStreamBuffer,
                                                ; GusStartStream
        db 00h,00h,00h,00h
GusStreamBusyLeft:                              ; used by GusServiceStream, GusStreamBusy, GusStreamVoiceIrq
        db 00h,00h,00h,00h
GusStreamRightBuf:                              ; Host buffer for the right stream half; used by
                                                ; GusFillStreamBuffer, GusStartStream
        db 00h,00h,00h,00h
GusStreamRightPending:                          ; Right half waits for refill; used by GusFillStreamBuffer,
                                                ; GusStartStream
        db 00h,00h,00h,00h
GusStreamBusyRight:                             ; used by GusServiceStream, GusStreamBusy, GusStreamVoiceIrq
        db 00h,00h,00h,00h
GusStreamChannels:                              ; Four GUS stream channel records of 258h bytes; used by
                                                ; GusFillStreamBuffer
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h
        db 00h,00h,00h,00h
        db 00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h
        db 00h,00h,00h,00h
        db 00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h
        db 00h,00h,00h,00h
        db 00h,00h,00h,00h
GusStreamStepsChan0:                            ; Sample step table of stream channel 0; used by
                                                ; GusFillStreamBuffer
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
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h
        db 00h,00h,00h,00h
        db 00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h
        db 00h,00h,00h,00h
        db 00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h
        db 00h,00h,00h,00h
        db 00h,00h,00h,00h
GusStreamStepsChan1:                            ; Sample step table of stream channel 1; used by
                                                ; GusFillStreamBuffer
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
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h
        db 00h,00h,00h,00h
        db 00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h
        db 00h,00h,00h,00h
        db 00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h
        db 00h,00h,00h,00h
        db 00h,00h,00h,00h
GusStreamStepsChan2:                            ; Sample step table of stream channel 2; used by
                                                ; GusFillStreamBuffer
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
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h
        db 00h,00h,00h,00h
        db 00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h
        db 00h,00h,00h,00h
        db 00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h
        db 00h,00h,00h,00h
        db 00h,00h,00h,00h
GusStreamStepsChan3:                            ; Sample step table of stream channel 3; used by
                                                ; GusFillStreamBuffer
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
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
GusStreamTable:                                 ; GUS stream records by channel; used by GusStartStream,
                                                ; GusStreamApplyBend, GusStreamGetVolume ...
        dd GusStreamChannels
        dd GusStreamChannels+0258h
        dd GusStreamChannels+04B0h
        dd GusStreamChannels+0708h
GusStreamBufSize:                               ; Size of the stream buffer in card memory; used by
                                                ; GusStartStream
        db 00h,00h,00h,00h
GusStreamHalfSize:                              ; Size of one half of the stream buffer; used by
                                                ; GusFillStreamBuffer, GusStartStream
        db 00h,00h,00h,00h
GusStreamQuarterSize:                           ; Quarter of the stream buffer size; used by
                                                ; GusFillStreamBuffer, GusStartStream, GusStreamSetRate
        db 00h,00h,00h,00h
GusStreamBufShift:                              ; Log2 of the buffer size; used by GusStartStream
        db 00h,00h,00h,00h
GusStreamHalfShift:                             ; Log2 of the half buffer size; used by GusStartStream
        db 00h,00h,00h,00h
GusStreamQuarterLog2:                           ; Log2 of the quarter buffer size; used by
                                                ; GusFillStreamBuffer, GusStartStream
        db 00h,00h,00h,00h
GusFillCount:                                   ; Samples handled by the current fill step; used by
                                                ; GusFillStreamBuffer
        db 00h,00h,00h,00h
GusStreamState:                                 ; Stream state; used by GusFillStreamBuffer, GusStartStream,
                                                ; GusStopStream
        db 00h,00h,00h,00h
GusStreamVoiceLeft:                             ; Voice playing the left stream half; used by GusStartStream,
                                                ; GusStopStream, GusStreamVoiceIrq
        db 00h,00h,00h,00h
GusStreamVoiceRight:                            ; Voice playing the right stream half; used by GusStartStream,
                                                ; GusStopStream, GusStreamVoiceIrq
        db 00h,00h,00h,00h,022h,056h,00h,00h
GusFillScratch:                                 ; Scratch value used during the fill; used by
                                                ; GusFillStreamBuffer
        db 00h,00h,00h,00h
GusFillDest:                                    ; Fill destination; used by GusFillStreamBuffer
        db 00h,00h,00h,00h
GusStreamCardLeft:                              ; Card memory address of the left stream half; used by
                                                ; GusFillStreamBuffer, GusStartStream
        db 00h,00h,00h,00h
GusStreamCardRight:                             ; Card memory address of the right stream half; used by
                                                ; GusFillStreamBuffer, GusStartStream
        db 00h,00h,00h,00h
GusStreamCardEnd:                               ; End of the stream buffers in card memory; used by
                                                ; GusFillStreamBuffer, GusStartStream
        db 00h,00h,00h,00h
GusStreamLoopLo:                                ; Low word of the stream voices' loop point; used by
                                                ; GusStartStream, GusStreamVoiceIrq
        db 00h,00h
GusStreamLoopHi:                                ; High word of the stream voices' loop point; used by
                                                ; GusStartStream, GusStreamVoiceIrq
        db 00h,00h
GusStreamStartLo:                               ; Low word of the stream voices' start address; used by
                                                ; GusStartStream
        db 00h,00h
GusStreamStartHi:                               ; High word of the stream voices' start address; used by
                                                ; GusStartStream
        db 00h,00h
GusStreamEndLo:                                 ; Low word of the stream voices' end address; used by
                                                ; GusStartStream
        db 00h,00h
GusStreamEndHi:                                 ; High word of the stream voices' end address; used by
                                                ; GusStartStream
        db 00h,00h,00h,080h,0Bh,00h
GusEnvVarName:                                  ; Points to the name of the environment variable that holds
                                                ; the card settings; used by GusGetEnvConfig
        dd str_ULTRASND
GusChanBendRange:                               ; Pitch bend range in semitones per MIDI channel; used by
                                                ; GusMidiController, GusMidiPitchBend
        db 02h,00h,00h,00h,02h,00h,00h,00h,02h,00h,00h,00h,02h,00h,00h,00h
        db 02h,00h,00h,00h,02h,00h,00h,00h,02h,00h,00h,00h,02h,00h,00h,00h
        db 02h,00h,00h,00h,02h,00h,00h,00h,02h,00h,00h,00h,02h,00h,00h,00h
        db 02h,00h,00h,00h,02h,00h,00h,00h,02h,00h,00h,00h,02h,00h,00h,00h
GusChanBendCents:                               ; Pitch bend range fine part per MIDI channel; used by
                                                ; GusMidiController
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
GusChanRpnMsb:                                  ; Registered parameter number MSB per MIDI channel (controller
                                                ; 65h); used by GusMidiController
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
GusChanRpnLsb:                                  ; Registered parameter number LSB per MIDI channel (controller
                                                ; 64h); used by GusMidiController
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
GusChanVolume:                                  ; Channel volume per MIDI channel (controller 7); used by
                                                ; GusMidiController
        db 064h,00h,00h,00h,064h,00h,00h,00h,064h,00h,00h,00h,064h,00h,00h,00h
        db 064h,00h,00h,00h,064h,00h,00h,00h,064h,00h,00h,00h,064h,00h,00h,00h
        db 064h,00h,00h,00h,064h,00h,00h,00h,064h,00h,00h,00h,064h,00h,00h,00h
        db 064h,00h,00h,00h,064h,00h,00h,00h,064h,00h,00h,00h,064h,00h,00h,00h
GusChanExpression:                              ; Expression per MIDI channel (controller 0Bh); used by
                                                ; GusMidiController
        db 07Fh,00h,00h,00h,07Fh,00h,00h,00h,07Fh,00h,00h,00h,07Fh,00h,00h,00h
        db 07Fh,00h,00h,00h,07Fh,00h,00h,00h,07Fh,00h,00h,00h,07Fh,00h,00h,00h
        db 07Fh,00h,00h,00h,07Fh,00h,00h,00h,07Fh,00h,00h,00h,07Fh,00h,00h,00h
        db 07Fh,00h,00h,00h,07Fh,00h,00h,00h,07Fh,00h,00h,00h,07Fh,00h,00h,00h
        db 010h,00h,00h,00h,010h,00h,00h,00h,010h,00h,00h,00h,010h,00h,00h,00h
        db 010h,00h,00h,00h,010h,00h,00h,00h,010h,00h,00h,00h,010h,00h,00h,00h
        db 010h,00h,00h,00h,010h,00h,00h,00h,010h,00h,00h,00h,010h,00h,00h,00h
        db 010h,00h,00h,00h,010h,00h,00h,00h,010h,00h,00h,00h,010h,00h,00h,00h
ExecParamBlock:                                 ; DOS exec parameter block for spawning a program; used by
                                                ; __dospawn
        db 00h,00h,00h,00h
        db 00h,00h
        db 00h,00h,00h,00h
        db 00h,00h
        db 00h,00h,00h,00h
        db 00h,00h
        db 00h,00h,00h,00h
        db 00h,00h
        db 00h,00h,00h,00h
        db 00h,00h,00h,00h
SpawnSavedEsp:                                  ; Stack pointer saved across the DOS exec call; used by
                                                ; __dospawn
        db 00h,00h,00h,00h
SpawnSavedSs:                                   ; Stack selector saved across the DOS exec call; used by
                                                ; __dospawn
        db 00h,00h
SpawnSavedDs:                                   ; Data selector saved across the DOS exec call; used by
                                                ; __dospawn
        db 00h,00h
BlitColumnOffsets:                              ; used by CopyRowFast, CopyRowKeyFF, CopyRowRemapKeyed ...
        db 00h,00h,00h,00h
BlitSourcePtr:                                  ; used by CopyRowFast, CopyRowKeyFF, CopyRowRemapKeyed ...
        db 00h,00h,00h,00h
DmaDefaultMode:                                 ; Default DMA mode value; used by SetDmaDefaultMode
        db 011h,00h,00h,00h,00h,00h,00h,00h
GusDmaPageTable:                                ; ISA DMA page port and channel bits for each DMA channel;
                                                ; used by GusSetupDmaChannel
        db 087h,00h,083h,00h,081h,00h,082h,00h,08Fh,00h,08Bh,00h,089h,00h,08Ah,00h
        db 00h,00h
GusIrqVectorTable:                              ; Interrupt vector and saved old handler of each card IRQ
                                                ; line; used by GusHookIrq, GusUnhookIrq
        db 08h,00h
GusIrqOldHandler:                               ; Saved old handler offset in the IRQ table; used by
                                                ; GusHookIrq, GusUnhookIrq
        db 00h,00h,00h,00h
GusIrqOldSelector:                              ; Saved old handler selector in the IRQ table; used by
                                                ; GusHookIrq, GusUnhookIrq
        db 00h,00h,09h,00h,00h,00h,00h,00h,00h,00h,0Ah,00h,00h,00h,00h,00h
        db 00h,00h,0Bh,00h,00h,00h,00h,00h,00h,00h,0Ch,00h,00h,00h,00h,00h
        db 00h,00h,0Dh,00h,00h,00h,00h,00h,00h,00h,0Eh,00h,00h,00h,00h,00h
        db 00h,00h,0Fh,00h,00h,00h,00h,00h,00h,00h,070h,00h,00h,00h,00h,00h
        db 00h,00h,071h,00h,00h,00h,00h,00h,00h,00h,072h,00h,00h,00h,00h,00h
        db 00h,00h,073h,00h,00h,00h,00h,00h,00h,00h,074h,00h,00h,00h,00h,00h
        db 00h,00h,075h,00h,00h,00h,00h,00h,00h,00h,076h,00h,00h,00h,00h,00h
        db 00h,00h,077h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
GusBasePort:                                    ; used by GusSetBasePort, GusSetIrqDmaLatches
        db 020h,02h
GusIrqStatusPort:                               ; used by GusDramDmaDone, GusMidiIrqService, GusReadIrqSource
                                                ; ...
        db 026h,02h
GusTimer1Count:                                 ; Count loaded into card timer 1; used by GusStartTimer1,
                                                ; GusStartTimer2
        db 028h,02h
GusTimer2Count:                                 ; Count loaded into card timer 2; used by GusStartTimer1,
                                                ; GusStartTimer2
        db 029h,02h
GusIrqLatchPort:                                ; Card port of the IRQ latch register; used by
                                                ; GusSetIrqDmaLatches
        db 02Bh,02h
GusDmaLatchPort:                                ; Card port of the DMA latch register; used by
                                                ; GusSetIrqDmaLatches
        db 02Fh,02h
GusMidiControlPort:                             ; MIDI control and status port; used by GusMidiIrqService
        db 020h,03h
GusMidiDataPort:                                ; MIDI data port; used by GusMidiIrqService
        db 021h,03h
GusVoiceSelectPort:                             ; used by GusMidiNoteOff, GusMidiNoteOn, GusResetVoices ...
        db 022h,03h
GusRegSelectPort:                               ; used by GusDmaNextChunk, GusMidiNoteOff, GusMidiNoteOn ...
        db 023h,03h
GusDataLowPort:                                 ; used by GusMidiNoteOff, GusMidiNoteOn, GusPeek ...
        db 024h,03h
GusDataHighPort:                                ; used by GusDmaNextChunk, GusMidiNoteOff, GusMidiNoteOn ...
        db 025h,03h
GusDramPort:                                    ; used by GusDelay, GusPeek, GusPoke ...
        db 027h,03h
GusDmaLatchBits:                                ; used by GusInitPlayDma, GusInitRecordDma,
                                                ; GusSetIrqDmaLatches
        db 00h,01h,00h,02h,00h,03h,04h,05h,00h,00h
GusDmaBusy:                                     ; used by GusDmaIdle, GusDmaNextChunk, GusDownload ...
        db 01h,00h,00h,00h
GusIrqPending:                                  ; used by GusClearIrqState
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h
GusMidiPending:                                 ; Used by GusMidiIrqHandler; used by GusMidiIrqHandler
        db 00h,00h,00h,00h,00h,00h,00h,00h
GusMidiIrqCount:                                ; used by GusClearCallbacks, GusMidiIrqService
        db 00h,00h,00h,00h
GusTimerCallback:                               ; used by GusClaimTimerCallback, GusClearCallbacks
        db 00h,00h,00h,00h
GusDmaDoneCallback:                             ; used by GusClearCallbacks, GusServiceIrq, GusSetDmaCallbacks
        db 00h,00h,00h,00h
GusRecordDoneCallback:                          ; used by GusClearCallbacks, GusServiceIrq, GusSetDmaCallbacks
        db 00h,00h,00h,00h
GusWaveCallback:                                ; used by GusClaimVoiceCallbacks, GusClearCallbacks,
                                                ; GusServiceIrq
        db 00h,00h,00h,00h
GusVolumeCallback:                              ; used by GusClaimVoiceCallbacks, GusClearCallbacks,
                                                ; GusServiceIrq
        db 00h,00h,00h,00h
GusTimer1Callback:                              ; used by GusClaimTimerCallbacks, GusClearCallbacks,
                                                ; GusServiceIrq
        db 00h,00h,00h,00h
GusTimer2Callback:                              ; used by GusClaimTimerCallbacks, GusClearCallbacks,
                                                ; GusServiceIrq
        db 00h,00h,00h,00h
GusWaveIrqCallback:                             ; used by GusClearCallbacks, GusServiceIrq,
                                                ; GusSetVoiceCallbacks
        db 00h,00h,00h,00h
GusVolumeIrqCallback:                           ; used by GusClearCallbacks, GusServiceIrq,
                                                ; GusSetVoiceCallbacks
        db 00h,00h,00h,00h
GusMidiXmitCallback:                            ; MIDI transmit callback; used by GusClaimMidiXmitCallback,
                                                ; GusClearCallbacks, GusMidiIrqService
        db 00h,00h,00h,00h
GusMidiRecvCallback:                            ; MIDI receive callback; used by GusClaimMidiRecvCallback,
                                                ; GusClearCallbacks, GusMidiIrqService
        db 00h,00h,00h,00h
GusMidiInitFlag:                                ; Set by GusMidiInit; used by GusMidiInit
        db 00h,00h,00h,00h
GusNoteFreqTable:                               ; GUS frequency per note; used by GusMidiNoteOn,
                                                ; GusNoteFrequency
        db 0EFh,01Fh,00h,00h
GusNoteFreqUpper:                               ; Frequency of the next note up, read for bends; used by
                                                ; GusNoteFrequency
        db 0D5h,021h,00h,00h,0D9h,023h,00h,00h,0FAh,025h,00h,00h,03Ch,028h,00h,00h
        db 0A1h,02Ah,00h,00h,02Ah,02Dh,00h,00h,0D9h,02Fh,00h,00h,0B2h,032h,00h,00h
        db 0B6h,035h,00h,00h,0E7h,038h,00h,00h,049h,03Ch,00h,00h,0DFh,03Fh,00h,00h
        db 0ABh,043h,00h,00h,0B2h,047h,00h,00h,0F5h,04Bh,00h,00h,079h,050h,00h,00h
        db 042h,055h,00h,00h,054h,05Ah,00h,00h,0B3h,05Fh,00h,00h,064h,065h,00h,00h
        db 06Ch,06Bh,00h,00h,0CFh,071h,00h,00h,093h,078h,00h,00h,0BFh,07Fh,00h,00h
        db 057h,087h,00h,00h,064h,08Fh,00h,00h,0EAh,097h,00h,00h,0F3h,0A0h,00h,00h
        db 085h,0AAh,00h,00h,0A9h,0B4h,00h,00h,067h,0BFh,00h,00h,0C9h,0CAh,00h,00h
        db 0D8h,0D6h,00h,00h,09Eh,0E3h,00h,00h,027h,0F1h,00h,00h,07Eh,0FFh,00h,00h
        db 0AFh,0Eh,01h,00h,0C8h,01Eh,01h,00h,0D5h,02Fh,01h,00h,0E6h,041h,01h,00h
        db 0Bh,055h,01h,00h,052h,069h,01h,00h,0CEh,07Eh,01h,00h,092h,095h,01h,00h
        db 0B0h,0ADh,01h,00h,03Ch,0C7h,01h,00h,04Eh,0E2h,01h,00h,0FCh,0FEh,01h,00h
        db 05Fh,01Dh,02h,00h,090h,03Dh,02h,00h,0ABh,05Fh,02h,00h,0CDh,083h,02h,00h
        db 016h,0AAh,02h,00h,0A5h,0D2h,02h,00h,09Dh,0FDh,02h,00h,024h,02Bh,03h,00h
        db 060h,05Bh,03h,00h,079h,08Eh,03h,00h,09Dh,0C4h,03h,00h,0F9h,0FDh,03h,00h
        db 0BEh,03Ah,04h,00h,020h,07Bh,04h,00h,056h,0BFh,04h,00h,09Bh,07h,05h,00h
        db 02Ch,054h,05h,00h,04Ah,0A5h,05h,00h,03Bh,0FBh,05h,00h,048h,056h,06h,00h
        db 0C0h,0B6h,06h,00h,0F3h,01Ch,07h,00h,03Bh,089h,07h,00h,0F3h,0FBh,07h,00h
        db 07Dh,075h,08h,00h,041h,0F6h,08h,00h,0ADh,07Eh,09h,00h,037h,0Fh,0Ah,00h
        db 058h,0A8h,0Ah,00h,094h,04Ah,0Bh,00h,076h,0F6h,0Bh,00h,091h,0ACh,0Ch,00h
        db 080h,06Dh,0Dh,00h,0E7h,039h,0Eh,00h,076h,012h,0Fh,00h,0E6h,0F7h,0Fh,00h
        db 0FAh,0EAh,010h,00h,083h,0ECh,011h,00h,05Bh,0FDh,012h,00h,06Eh,01Eh,014h,00h
        db 0B0h,050h,015h,00h,029h,095h,016h,00h,0EDh,0ECh,017h,00h,022h,059h,019h,00h
        db 00h,0DBh,01Ah,00h,0CFh,073h,01Ch,00h,0EDh,024h,01Eh,00h,0CCh,0EFh,01Fh,00h
        db 0F5h,0D5h,021h,00h,06h,0D9h,023h,00h,0B7h,0FAh,025h,00h,0DCh,03Ch,028h,00h
        db 061h,0A1h,02Ah,00h,053h,02Ah,02Dh,00h,0DBh,0D9h,02Fh,00h,045h,0B2h,032h,00h
        db 00h,0B6h,035h,00h,09Eh,0E7h,038h,00h,0DAh,049h,03Ch,00h,099h,0DFh,03Fh,00h
        db 0EAh,0ABh,043h,00h,0Ch,0B2h,047h,00h,06Fh,0F5h,04Bh,00h,0B8h,079h,050h,00h
        db 0C3h,042h,055h,00h,0A6h,054h,05Ah,00h,0B6h,0B3h,05Fh,00h,08Bh,064h,065h,00h
        db 00h,06Ch,06Bh,00h,03Ch,0CFh,071h,00h,0B4h,093h,078h,00h,032h,0BFh,07Fh,00h
        db 0D4h,057h,087h,00h,018h,064h,08Fh,00h,0DFh,0EAh,097h,00h,071h,0F3h,0A0h,00h
        db 087h,085h,0AAh,00h,04Dh,0A9h,0B4h,00h
GusFreqDivisor:                                 ; Divisor used to turn note frequencies into GUS frequency
                                                ; control values; used by GusNoteFrequency
        db 00h,00h,00h,00h
GusVoiceAllocAge:                               ; Running counter used to pick the oldest voice; used by
                                                ; GusAllocVoice
        db 01h,00h,00h,00h
GusDramSized:                                   ; Set once the card memory size has been measured; used by
                                                ; GusSizeDram
        db 00h,00h,00h,00h
