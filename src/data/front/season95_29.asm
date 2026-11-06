; Which teams share a division, and how many days each month has.
bits 32
%include "hockey.inc"
section s_C83C3 progbits alloc noexec write align=1
global divisionteams, teamdivision, teamdivslot, monthdays_m1
divisionteams:
db 018h,02h,05h,07h,012h,015h,063h,03h,08h,04h,011h,014h,017h,063h,00h,01h
db 06h,09h,0Dh,0Fh,010h,019h,0Ah,0Bh,0Ch,0Eh,013h,016h
teamdivision:
db 02h,02h,00h,01h,01h,00h,02h,00h,01h,02h,03h,03h,03h,02h,03h,02h
db 02h,01h,00h,03h,01h,00h,03h,01h,00h,03h
teamdivslot:
db 00h,01h,01h,00h,02h,02h,02h,03h,01h,03h,01h,02h,03h,04h,04h,05h
db 06h,03h,04h,05h,04h,05h,06h,05h,00h,00h,00h,00h,01h,01h,00h,01h
db 00h,01h,01h,00h,00h,01h,00h,01h,00h,03h,01h,02h,044h,04h,00h,00h
db 07Ch,04h,00h,00h,098h,04h,00h,00h,0A6h,04h,00h,00h,08h,00h,00h,00h
db 04h,00h,00h,00h,02h,00h,00h,00h,01h,00h,00h
monthdays_m1:
db 00h
