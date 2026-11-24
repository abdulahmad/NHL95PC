; Strings and constants of src/lib/ea/ea_memman_alloc.asm, in link order.
bits 32
%include "hockey.inc"
section s_C3B98 progbits alloc noexec write align=1
global str_LOWMEM, str_HIGHMEM, str_GAP, str_ReleaseMemoryNotFound, str_ReservememINVALIDSIZE, str_ReservememOUTOFMEMORY, str_ReservememOUTOFMEMORY2, str_ReservememINVALIDTYPEFLAGS
global str_ResizememINVALIDSIZE, str_ResizememblockNOROOMTO, str_FindmemblockBLOCKNOTFOUND
str_LOWMEM:                                     ; "LOW MEM" string literal; used by InitMemList
        db 04Ch,04Fh,057h,020h,04Dh,045h,04Dh,00h
str_HIGHMEM:                                    ; "HIGH MEM" string literal; used by AddHighMemList,
                                                ; InitMemList
        db 048h,049h,047h,048h,020h,04Dh,045h,04Dh,00h,020h,020h,020h
str_GAP:                                        ; "GAP" string literal; used by AddHighMemList
        db 047h,041h,050h,00h
str_ReleaseMemoryNotFound:                      ; "Release Memory Not Found\n" string literal; used by
                                                ; FindMemListBlock
        db 052h,065h,06Ch,065h,061h,073h,065h,020h,04Dh,065h,06Dh,06Fh,072h,079h,020h,04Eh
        db 06Fh,074h,020h,046h,06Fh,075h,06Eh,064h,0Ah,00h,065h,02Ch
str_ReservememINVALIDSIZE:                      ; "reservemem - INVALID SIZE REQUESTED\nrequested: %ld
                                                ; available: %ld\n" string literal; used by reservemem
        db 072h,065h,073h,065h,072h,076h,065h,06Dh,065h,06Dh,020h,02Dh,020h,049h,04Eh,056h
        db 041h,04Ch,049h,044h,020h,053h,049h,05Ah,045h,020h,052h,045h,051h,055h,045h,053h
        db 054h,045h,044h,0Ah,072h,065h,071h,075h,065h,073h,074h,065h,064h,03Ah,020h,025h
        db 06Ch,064h,020h,061h,076h,061h,069h,06Ch,061h,062h,06Ch,065h,03Ah,020h,025h,06Ch
        db 064h,0Ah,00h,072h
str_ReservememOUTOFMEMORY:                      ; "reservemem - OUT OF MEMORY\nrequested: %ld available:
                                                ; %ld\n" string literal; used by reservemem
        db 072h,065h,073h,065h,072h,076h,065h,06Dh,065h,06Dh,020h,02Dh,020h,04Fh,055h,054h
        db 020h,04Fh,046h,020h,04Dh,045h,04Dh,04Fh,052h,059h,0Ah,072h,065h,071h,075h,065h
        db 073h,074h,065h,064h,03Ah,020h,025h,06Ch,064h,020h,061h,076h,061h,069h,06Ch,061h
        db 062h,06Ch,065h,03Ah,020h,025h,06Ch,064h,0Ah,00h,00h,00h
str_ReservememOUTOFMEMORY2:                     ; "reservemem - OUT OF MEMORY\nrequested: %ld available:
                                                ; %ld\n" string literal; used by reservemem
        db 072h,065h,073h,065h,072h,076h,065h,06Dh,065h,06Dh,020h,02Dh,020h,04Fh,055h,054h
        db 020h,04Fh,046h,020h,04Dh,045h,04Dh,04Fh,052h,059h,0Ah,072h,065h,071h,075h,065h
        db 073h,074h,065h,064h,03Ah,020h,025h,06Ch,064h,020h,061h,076h,061h,069h,06Ch,061h
        db 062h,06Ch,065h,03Ah,020h,025h,06Ch,064h,0Ah,00h,065h,06Dh
str_ReservememINVALIDTYPEFLAGS:                 ; "reservemem - INVALID TYPE FLAGS (%04x)\n" string literal;
                                                ; used by reservemem
        db 072h,065h,073h,065h,072h,076h,065h,06Dh,065h,06Dh,020h,02Dh,020h,049h,04Eh,056h
        db 041h,04Ch,049h,044h,020h,054h,059h,050h,045h,020h,046h,04Ch,041h,047h,053h,020h
        db 028h,025h,030h,034h,078h,029h,0Ah,00h
str_ResizememINVALIDSIZE:                       ; "resizemem - INVALID SIZE REQUESTED\nrequested: %ld
                                                ; available: %ld\n" string literal; used by ResizeMemBlock
        db 072h,065h,073h,069h,07Ah,065h,06Dh,065h,06Dh,020h,02Dh,020h,049h,04Eh,056h,041h
        db 04Ch,049h,044h,020h,053h,049h,05Ah,045h,020h,052h,045h,051h,055h,045h,053h,054h
        db 045h,044h,0Ah,072h,065h,071h,075h,065h,073h,074h,065h,064h,03Ah,020h,025h,06Ch
        db 064h,020h,061h,076h,061h,069h,06Ch,061h,062h,06Ch,065h,03Ah,020h,025h,06Ch,064h
        db 0Ah,00h,06Ch,061h
str_ResizememblockNOROOMTO:                     ; "resizememblock - NO ROOM TO RESIZE\nrequested: %ld
                                                ; available: %ld\n" string literal; used by ResizeMemBlock
        db 072h,065h,073h,069h,07Ah,065h,06Dh,065h,06Dh,062h,06Ch,06Fh,063h,06Bh,020h,02Dh
        db 020h,04Eh,04Fh,020h,052h,04Fh,04Fh,04Dh,020h,054h,04Fh,020h,052h,045h,053h,049h
        db 05Ah,045h,0Ah,072h,065h,071h,075h,065h,073h,074h,065h,064h,03Ah,020h,025h,06Ch
        db 064h,020h,061h,076h,061h,069h,06Ch,061h,062h,06Ch,065h,03Ah,020h,025h,06Ch,064h
        db 0Ah,00h,061h,062h
str_FindmemblockBLOCKNOTFOUND:                  ; "findmemblock - BLOCK NOT FOUND (%p)\n" string literal; used
                                                ; by findmemblock
        db 066h,069h,06Eh,064h,06Dh,065h,06Dh,062h,06Ch,06Fh,063h,06Bh,020h,02Dh,020h,042h
        db 04Ch,04Fh,043h,04Bh,020h,04Eh,04Fh,054h,020h,046h,04Fh,055h,04Eh,044h,020h,028h
        db 025h,070h,029h,0Ah,00h,046h,04Ch,041h
