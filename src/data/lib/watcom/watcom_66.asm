; Watcom runtime data.
bits 32
%include "hockey.inc"
section s_D657C progbits alloc noexec write align=1
extern nullsub_3
global byte_D65F8, byte_D65F9, off_D6600, off_D6604, unk_D657C, word_D65FC
unk_D657C:
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
byte_D65F8:
db 00h
byte_D65F9:
db 00h,00h,00h
word_D65FC:
db 07Fh,012h,00h,00h
off_D6600:
dd nullsub_3
off_D6604:
dd nullsub_3
