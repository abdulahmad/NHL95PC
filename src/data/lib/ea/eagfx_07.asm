; Zone manager messages for a missing window.
bits 32
%include "hockey.inc"
section s_C2778 progbits alloc noexec write align=1
global str_ZMHiddenWindowNoHiddenWindow, str_ZMBackgroundWindowNo, str_ZONEMGR
str_ZMHiddenWindowNoHiddenWindow:
        db 05Ah,04Dh,048h,069h,064h,064h,065h,06Eh,057h,069h,06Eh,064h,06Fh,077h,03Ah,020h
        db 04Eh,06Fh,020h,068h,069h,064h,064h,065h,06Eh,020h,077h,069h,06Eh,064h,06Fh,077h
        db 00h
str_ZMBackgroundWindowNo:
        db 05Ah,04Dh,042h,061h,063h,06Bh,067h,072h,06Fh,075h,06Eh,064h,057h,069h,06Eh,064h
        db 06Fh,077h,03Ah,020h,04Eh,06Fh,020h,062h,061h,063h,06Bh,067h,072h,06Fh,075h,06Eh
        db 064h,020h,077h,069h,06Eh,064h,06Fh,077h,00h
str_ZONEMGR:
        db 05Ah,04Fh,04Eh,045h,04Dh,047h,052h,00h,00h,00h
