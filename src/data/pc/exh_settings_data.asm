; Initialised data of pc/exh_settings (src/pc/exh_settings).
bits 32
%include "hockey.inc"
section s_D17EC progbits alloc noexec write align=1
global exhsetrects
exhsetrects:                                    ; rects; used by DrawExhSetChecks, ExhSetHitTest
        db 018h,00h,00h,00h
        db 028h,00h,00h,00h
        db 032h,00h,00h,00h
        db 038h,00h,00h,00h,036h,00h,00h,00h,028h,00h,00h,00h,050h,00h,00h,00h
        db 038h,00h,00h,00h,018h,00h,00h,00h,03Eh,00h,00h,00h,032h,00h,00h,00h
        db 04Eh,00h,00h,00h,036h,00h,00h,00h,03Eh,00h,00h,00h,050h,00h,00h,00h
        db 04Eh,00h,00h,00h,018h,00h,00h,00h,054h,00h,00h,00h,032h,00h,00h,00h
        db 064h,00h,00h,00h,036h,00h,00h,00h,054h,00h,00h,00h,050h,00h,00h,00h
        db 064h,00h,00h,00h,018h,00h,00h,00h,06Ah,00h,00h,00h,032h,00h,00h,00h
        db 07Ah,00h,00h,00h,036h,00h,00h,00h,06Ah,00h,00h,00h,050h,00h,00h,00h
        db 07Ah,00h,00h,00h,018h,00h,00h,00h,080h,00h,00h,00h,032h,00h,00h,00h
        db 090h,00h,00h,00h,036h,00h,00h,00h,080h,00h,00h,00h,050h,00h,00h,00h
        db 090h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
        db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
        db 0FFh,0FFh,0FFh,0FFh,018h,00h,00h,00h,096h,00h,00h,00h,032h,00h,00h,00h
        db 0A6h,00h,00h,00h,036h,00h,00h,00h,096h,00h,00h,00h,050h,00h,00h,00h
        db 0A6h,00h,00h,00h,018h,00h,00h,00h,0ACh,00h,00h,00h,032h,00h,00h,00h
        db 0BCh,00h,00h,00h,036h,00h,00h,00h,0ACh,00h,00h,00h,050h,00h,00h,00h
        db 0BCh,00h,00h,00h,018h,00h,00h,00h,0C2h,00h,00h,00h,032h,00h,00h,00h
        db 0D2h,00h,00h,00h,036h,00h,00h,00h,0C2h,00h,00h,00h,050h,00h,00h,00h
        db 0D2h,00h,00h,00h,074h,00h,00h,00h,0EAh,00h,00h,00h,089h,00h,00h,00h
        db 0FAh,00h,00h,00h,08Eh,00h,00h,00h,0EAh,00h,00h,00h,0A5h,00h,00h,00h
        db 0FAh,00h,00h,00h,0AAh,00h,00h,00h,0EAh,00h,00h,00h,0C1h,00h,00h,00h
        db 0FAh,00h,00h,00h,02Dh,00h,00h,00h,0Dh,01h,00h,00h,05Eh,00h,00h,00h
        db 01Dh,01h,00h,00h,077h,00h,00h,00h,0Dh,01h,00h,00h,0A8h,00h,00h,00h
        db 01Dh,01h,00h,00h
