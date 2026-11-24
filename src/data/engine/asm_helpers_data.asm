; Initialised data of engine/asm_helpers (src/engine/asm_helpers).
bits 32
%include "hockey.inc"
section s_D2C74 progbits alloc noexec write align=1
global vtoa_dt
vtoa_dt:                                        ; used by vtoa
        db 01h,07h,03h,05h,00h,00h,04h,04h,02h,06h,02h,06h,01h,07h,03h,05h
