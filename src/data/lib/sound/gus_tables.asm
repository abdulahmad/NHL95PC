; Tables for the sound drivers.
bits 32
%include "hockey.inc"
section s_D8ACC progbits alloc noexec write align=1
extern __InitFiles_, __chk8087_, __delay_init_, __full_io_exit_, __setEFGfmt_, __setenvp_, j___sys_fini_387_emulator, j___sys_init_387_emulator
extern SaveSS, GusMidiInit, GusSizeDram, GusInitDma, GusResetTimers, GusResetVoiceAlloc
global GusDmaReady, GusTimerCtrl, GusVoiceAllocCtrl, InitRtnsEntry, FiniRtnsEntry, GusInitTable, GusVoiceRateTable
GusVoiceRateTable:                              ; used by GusCalcVoiceAddrs
        db 0BCh,0BCh,0BCh,0BCh,0BCh,0BCh,0BCh,0BCh,0BCh,0BCh,0BCh,0BCh,0BCh,0BCh,0BCh,0BCh
        db 0BCh,0BCh,0BCh,0BCh,0BCh,0BCh,0BCh,018h
GusDmaReady:                                    ; DMA set-up flag, set by GusInitDma; it sits in slot 12 of
                                                ; GusVoiceRateTable, which is only read from 14 voices up
        db 00h,00h,00h,00h,044h,0ACh,0C8h,0A0h,0BBh,096h,0DDh,08Dh,0FCh,085h,0EEh,07Eh
        db 096h,078h,0D8h,072h,09Fh,06Dh,0DBh,068h,07Dh,064h,078h,060h,0C2h,05Ch,052h,059h
        db 022h,056h,029h,053h,064h,050h,0CCh,04Dh,05Dh,04Bh
GusTimerCtrl:                                   ; Timer control byte cleared by GusResetTimers; used by
                                                ; GusResetTimers
        db 00h,00h
GusVoiceAllocCtrl:                              ; Byte cleared by GusResetVoiceAlloc; used by
                                                ; GusResetVoiceAlloc
        db 00h,00h,00h,00h
InitRtnsEntry:                                  ; used by __InitRtns
        db 00h,020h
        dd SaveSS
        db 00h,020h
        dd __setEFGfmt_
        db 00h,01h
        dd j___sys_init_387_emulator
        db 00h,02h
        dd __chk8087_
        db 00h,020h
        dd __delay_init_
        db 00h,020h
        dd __InitFiles_
        db 00h,020h
        dd __setenvp_
FiniRtnsEntry:                                  ; used by __FiniRtns, __InitRtns
        db 00h,01h
        dd j___sys_fini_387_emulator
        db 00h,020h
        dd __full_io_exit_
GusInitTable:                                   ; used by GusRunInitTable, __FiniRtns
        db 00h,02h
        dd GusMidiInit
        db 00h,00h
        dd GusSizeDram
        db 00h,00h
        dd GusInitDma
        db 00h,00h
        dd GusResetTimers
        db 00h,00h
        dd GusResetVoiceAlloc
