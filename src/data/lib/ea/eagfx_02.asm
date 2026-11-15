; Error text for the movie player and the CD stream.
bits 32
%include "hockey.inc"
section s_C09A0 progbits alloc noexec write align=1
global str_CmvMemBlock, str_CmvPalette, str_CDSTREAM, str_IllegalSecondaryStreamNumber, str_SECCDSTREAM, str_IllegalChunkSizeD
str_CmvMemBlock:
db 063h,06Dh,076h,020h,06Dh,065h,06Dh,020h,062h,06Ch,06Fh,063h,06Bh,00h
str_CmvPalette:
db 063h,06Dh,076h,020h,070h,061h,06Ch,065h,074h,074h,065h,00h,00h,00h
str_CDSTREAM:
db 043h,044h,053h,054h,052h,045h,041h,04Dh,00h
str_IllegalSecondaryStreamNumber:
db 049h,06Ch,06Ch,065h,067h,061h,06Ch,020h,053h,065h,063h,06Fh,06Eh,064h,061h,072h
db 079h,020h,053h,074h,072h,065h,061h,06Dh,020h,04Eh,075h,06Dh,062h,065h,072h,0Ah
db 00h
str_SECCDSTREAM:
db 053h,045h,043h,043h,044h,053h,054h,052h,045h,041h,04Dh,00h
str_IllegalChunkSizeD:
db 049h,06Ch,06Ch,065h,067h,061h,06Ch,020h,063h,068h,075h,06Eh,06Bh,020h,073h,069h
db 07Ah,065h,020h,025h,064h,020h,062h,075h,066h,066h,065h,072h,073h,069h,07Ah,065h
db 020h,025h,064h,0Ah,00h,00h
