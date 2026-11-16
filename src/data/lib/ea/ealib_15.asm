; Whether a joystick is plugged in, and the queue of pad samples.
bits 32
%include "hockey.inc"
section s_C4B6C progbits alloc noexec write align=1
global CharClassTable, byte_C4C70, ScanBitMasks, DblMaxLow, DblMaxHigh, DblMinusMaxLow, DblMinusMaxHigh, HugeValLo
global HugeValHi, dword_C4CFC, joypresent, inputticks, joysampling, joyqhead, joyqcount
global F64_Scale10Max, F64_Scale10Min, Pow10Table, Scale10Count
CharClassTable:
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
byte_C4C70:
        db 01h,02h,04h,08h,010h,020h,040h,080h
ScanBitMasks:
        db 01h,02h,04h,08h,010h,020h,040h,080h
F64_Scale10Max:
        db 00h,00h,00h,00h,00h,00h,0F0h,07Fh
F64_Scale10Min:
        db 00h,00h,00h,00h,00h,00h,0F0h,0FFh
DblMaxLow:
        db 0FFh,0FFh,0FFh,0FFh
DblMaxHigh:
        db 0FFh,0FFh,0EFh,07Fh
DblMinusMaxLow:
        db 0FFh,0FFh,0FFh,0FFh
DblMinusMaxHigh:
        db 0FFh,0FFh,0EFh,0FFh
HugeValLo:
        db 00h,00h,00h,00h
HugeValHi:
        db 00h,00h,0F0h,07Fh
Scale10Count:
        db 0D8h,00h
Pow10Table:
        db 0C6h,0F9h,0C6h,040h,0E9h,034h,0C7h,06Ch,06Ch,00h,012h,04Eh,083h,0CCh,03Dh,040h
        db 05Bh,056h,036h,00h,0CEh,0C9h,014h,088h,087h,0E1h,024h,04Bh,01Bh,00h,02h,084h
        db 0FEh,0E4h,071h,0D9h,089h,045h,0Eh,00h,00h,00h,090h,01Eh,0C4h,0BCh,0D6h,042h
        db 08h,00h,00h,00h,00h,00h,084h,0D7h,097h,041h,04h,00h,00h,00h,00h,00h
        db 00h,088h,0C3h,040h,01h,00h,00h,00h,00h,00h,00h,00h,024h,040h,00h,00h
        db 00h,00h
dword_C4CFC:
        db 00h,00h,00h,00h
joypresent:
        db 00h,00h,00h,00h
        db 00h,00h,00h,00h
inputticks:
        db 00h,00h,00h,00h
joysampling:
        db 00h,00h,00h,00h
joyqhead:
        db 00h,00h,00h,00h
joyqcount:
        db 00h,00h,00h,00h
