; Tables for the sound drivers.
bits 32
%include "hockey.inc"
section s_D8ACC progbits alloc noexec write align=1
extern __InitFiles_, __chk8087_, __delay_init_, __full_io_exit_, __setEFGfmt_, __setenvp_, j___sys_fini_387_emulator, j___sys_init_387_emulator
extern SaveSS, sub_AB180, GusSizeDram, GusInitDma, sub_B19E0, sub_B1C70
global GusDmaReady, byte_D8B0E, byte_D8B10, InitRtnsEntry, FiniRtnsEntry, GusInitTable, word_D8ACC
word_D8ACC:
        db 0BCh,0BCh,0BCh,0BCh,0BCh,0BCh,0BCh,0BCh,0BCh,0BCh,0BCh,0BCh,0BCh,0BCh,0BCh,0BCh
        db 0BCh,0BCh,0BCh,0BCh,0BCh,0BCh,0BCh,018h
GusDmaReady:
        db 00h,00h,00h,00h,044h,0ACh,0C8h,0A0h,0BBh,096h,0DDh,08Dh,0FCh,085h,0EEh,07Eh
        db 096h,078h,0D8h,072h,09Fh,06Dh,0DBh,068h,07Dh,064h,078h,060h,0C2h,05Ch,052h,059h
        db 022h,056h,029h,053h,064h,050h,0CCh,04Dh,05Dh,04Bh
byte_D8B0E:
        db 00h,00h
byte_D8B10:
        db 00h,00h,00h,00h
InitRtnsEntry:
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
FiniRtnsEntry:
        db 00h,01h
        dd j___sys_fini_387_emulator
        db 00h,020h
        dd __full_io_exit_
GusInitTable:
        db 00h,02h
        dd sub_AB180
        db 00h,00h
        dd GusSizeDram
        db 00h,00h
        dd GusInitDma
        db 00h,00h
        dd sub_B19E0
        db 00h,00h
        dd sub_B1C70
