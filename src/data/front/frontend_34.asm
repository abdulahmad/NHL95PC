; The shuffled line orders used when a game is simulated, and whether the loading picture is up.
bits 32
%include "hockey.inc"
section s_C900C progbits alloc noexec write align=1
global simfwdorder, simdorder, loadscreenon
simfwdorder:
db 00h,00h,00h,00h,01h,00h,00h,00h,02h,00h,00h,00h,03h,00h,00h,00h
db 00h,00h,00h,00h,01h,00h,00h,00h,02h,00h,00h,00h,00h,00h,00h,00h
db 01h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,01h,00h,00h,00h
db 02h,00h,00h,00h,03h,00h,00h,00h,00h,00h,00h,00h,01h,00h,00h,00h
db 02h,00h,00h,00h,00h,00h,00h,00h,01h,00h,00h,00h,00h,00h,00h,00h
simdorder:
db 00h,00h,00h,00h,01h,00h,00h,00h,02h,00h,00h,00h,00h,00h,00h,00h
db 01h,00h,00h,00h,02h,00h,00h,00h
loadscreenon:
db 00h,00h,00h,00h
