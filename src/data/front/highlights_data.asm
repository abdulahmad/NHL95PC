; Initialised data of front/highlights (src/front/highlights).
bits 32
%include "hockey.inc"
section s_D1F4B progbits alloc noexec write align=1
extern str_ThereAreNoHilights
global msg_NoHilights, str_ThereIsNotEnogh, str_TheFloppyDiskFor, str_SelectLessHilightsOr, str_ThereIsNotEnogh2, str_TheHardDiskFor, str_TrySelectingLessHilights, str_TheHilight
global str_AlreadyExists, str_ExportingHilights, str_HilightDescFmt
msg_NoHilights:                                 ; message 'There are no hilights!'; used by SelectHilight
        dd str_ThereAreNoHilights
str_ThereIsNotEnogh:                            ; "There is not enogh space on" string literal
        db 054h,068h,065h,072h,065h,020h,069h,073h,020h,06Eh,06Fh,074h,020h,065h,06Eh,06Fh
        db 067h,068h,020h,073h,070h,061h,063h,065h,020h,06Fh,06Eh,00h
str_TheFloppyDiskFor:                           ; "the floppy disk for the hilights!" string literal
        db 074h,068h,065h,020h,066h,06Ch,06Fh,070h,070h,079h,020h,064h,069h,073h,06Bh,020h
        db 066h,06Fh,072h,020h,074h,068h,065h,020h,068h,069h,06Ch,069h,067h,068h,074h,073h
        db 021h,00h
str_SelectLessHilightsOr:                       ; "Select less hilights or get another disk." string literal
        db 053h,065h,06Ch,065h,063h,074h,020h,06Ch,065h,073h,073h,020h,068h,069h,06Ch,069h
        db 067h,068h,074h,073h,020h,06Fh,072h,020h,067h,065h,074h,020h,061h,06Eh,06Fh,074h
        db 068h,065h,072h,020h,064h,069h,073h,06Bh,02Eh,00h
        dd str_ThereIsNotEnogh
        dd str_TheFloppyDiskFor
        dd str_SelectLessHilightsOr
str_ThereIsNotEnogh2:                           ; "There is not enogh space on" string literal
        db 054h,068h,065h,072h,065h,020h,069h,073h,020h,06Eh,06Fh,074h,020h,065h,06Eh,06Fh
        db 067h,068h,020h,073h,070h,061h,063h,065h,020h,06Fh,06Eh,00h
str_TheHardDiskFor:                             ; "the hard disk for the hilights!" string literal
        db 074h,068h,065h,020h,068h,061h,072h,064h,020h,064h,069h,073h,06Bh,020h,066h,06Fh
        db 072h,020h,074h,068h,065h,020h,068h,069h,06Ch,069h,067h,068h,074h,073h,021h,00h
str_TrySelectingLessHilights:                   ; "Try selecting less hilights." string literal
        db 054h,072h,079h,020h,073h,065h,06Ch,065h,063h,074h,069h,06Eh,067h,020h,06Ch,065h
        db 073h,073h,020h,068h,069h,06Ch,069h,067h,068h,074h,073h,02Eh,00h
        dd str_ThereIsNotEnogh2
        dd str_TheHardDiskFor
        dd str_TrySelectingLessHilights
str_TheHilight:                                 ; "The hilight" string literal
        db 054h,068h,065h,020h,068h,069h,06Ch,069h,067h,068h,074h,00h
str_AlreadyExists:                              ; "already exists." string literal
        db 061h,06Ch,072h,065h,061h,064h,079h,020h,065h,078h,069h,073h,074h,073h,02Eh,00h
        dd str_TheHilight
        db 00h,00h,00h,00h
        dd str_AlreadyExists
str_ExportingHilights:                          ; "Exporting hilights" string literal
        db 045h,078h,070h,06Fh,072h,074h,069h,06Eh,067h,020h,068h,069h,06Ch,069h,067h,068h
        db 074h,073h,00h,049h,06Dh,070h,06Fh,072h,074h,069h,06Eh,067h,020h,068h,069h,06Ch
        db 069h,067h,068h,074h,073h,00h
        dd str_ExportingHilights
str_HilightDescFmt:                             ; string '%d %d, %s vs %s, Period %d, Time %02d:%02d.'; used
                                                ; by FormatHilightDesc
        db 025h,064h,020h,025h,064h,02Ch,020h,025h,073h,020h,076h,073h,020h,025h,073h,02Ch
        db 020h,050h,065h,072h,069h,06Fh,064h,020h,025h,064h,02Ch,020h,054h,069h,06Dh,065h
        db 020h,025h,030h,032h,064h,03Ah,025h,030h,032h,064h,02Eh,00h,00h,00h
