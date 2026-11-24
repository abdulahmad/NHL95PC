; Strings and constants of src/lib/watcom/watcom_float_convert.asm, in link order.
bits 32
%include "hockey.inc"
section s_C4B5C progbits alloc noexec write align=1
global str_Inf, str_Nan, F64_neg1_floor_, CharClassTable, CLibBitMasks, ScanBitMasks, F64_Scale10Max, F64_Scale10Min
global DblMaxLow, DblMaxHigh, DblMinusMaxLow, DblMinusMaxHigh, HugeValLo, HugeValHi, Scale10Count, Pow10Table
str_Inf:                                        ; "inf" string literal; used by __Nan_Inf_
        db 069h,06Eh,066h,00h
str_Nan:                                        ; "nan" string literal; used by __Nan_Inf_
        db 06Eh,061h,06Eh,00h
F64_neg1_floor_:                                ; double constant -1; used by floor_
        db 00h,00h,00h,00h,00h
        db 00h,0F0h,0BFh
CharClassTable:                                 ; Run-time library character classes; used by EditTextField,
                                                ; InputDialog, ScanChars ...
        db 00h,01h,01h,01h,01h,01h,01h,01h,01h,01h,03h,03h,03h,03h,03h,01h
        db 01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h
        db 01h,0Ah,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch
        db 0Ch,038h,038h,038h,038h,038h,038h,038h,038h,038h,038h,0Ch,0Ch,0Ch,0Ch,0Ch
        db 0Ch,0Ch,058h,058h,058h,058h,058h,058h,048h,048h,048h,048h,048h,048h,048h,048h
        db 048h,048h,048h,048h,048h,048h,048h,048h,048h,048h,048h,048h,0Ch,0Ch,0Ch,0Ch
        db 0Ch,0Ch,098h,098h,098h,098h,098h,098h,088h,088h,088h,088h,088h,088h,088h,088h
        db 088h,088h,088h,088h,088h,088h,088h,088h,088h,088h,088h,088h,0Ch,0Ch,0Ch,0Ch
        db 01h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h
CLibBitMasks:                                   ; Bit mask per bit number (1 2 4 ...) used by the C library
                                                ; set routines
        db 01h,02h,04h,08h,010h,020h,040h,080h
ScanBitMasks:                                   ; used by ScanBuildCharSet, ScanCharSet
        db 01h,02h,04h,08h,010h,020h,040h,080h
F64_Scale10Max:                                 ; used by _Scale10V_
        db 00h,00h,00h,00h,00h,00h,0F0h,07Fh
F64_Scale10Min:                                 ; used by _Scale10V_
        db 00h,00h,00h,00h,00h,00h,0F0h,0FFh
DblMaxLow:                                      ; used by _Scale10V_
        db 0FFh,0FFh,0FFh,0FFh
DblMaxHigh:                                     ; used by _Scale10V_
        db 0FFh,0FFh,0EFh,07Fh
DblMinusMaxLow:                                 ; used by _Scale10V_
        db 0FFh,0FFh,0FFh,0FFh
DblMinusMaxHigh:                                ; used by _Scale10V_
        db 0FFh,0FFh,0EFh,0FFh
HugeValLo:                                      ; Low half of HUGE_VAL; used by strtod_
        db 00h,00h,00h,00h
HugeValHi:                                      ; High half of HUGE_VAL; used by strtod_
        db 00h,00h,0F0h,07Fh
Scale10Count:                                   ; used by _Scale10V_
        db 0D8h,00h
Pow10Table:                                     ; used by _Scale10V_
        db 0C6h,0F9h,0C6h,040h,0E9h,034h,0C7h,06Ch,06Ch,00h,012h,04Eh,083h,0CCh,03Dh,040h
        db 05Bh,056h,036h,00h,0CEh,0C9h,014h,088h,087h,0E1h,024h,04Bh,01Bh,00h,02h,084h
        db 0FEh,0E4h,071h,0D9h,089h,045h,0Eh,00h,00h,00h,090h,01Eh,0C4h,0BCh,0D6h,042h
        db 08h,00h,00h,00h,00h,00h,084h,0D7h,097h,041h,04h,00h,00h,00h,00h,00h
        db 00h,088h,0C3h,040h,01h,00h,00h,00h,00h,00h,00h,00h,024h,040h,00h,00h
        db 00h,00h
