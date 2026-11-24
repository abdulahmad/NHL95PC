; Strings and constants of src/lib/ea/ea_memman_free.asm, in link order.
bits 32
%include "hockey.inc"
section s_C3D60 progbits alloc noexec write align=1
global str_GetmemblockNOMEMORYBLOCKS
str_GetmemblockNOMEMORYBLOCKS:                  ; "getmemblock - NO MEMORY BLOCKS LEFT\n" string literal; used
                                                ; by getmemblock
        db 067h,065h,074h,06Dh,065h,06Dh,062h,06Ch,06Fh,063h,06Bh,020h,02Dh,020h,04Eh,04Fh
        db 020h,04Dh,045h,04Dh,04Fh,052h,059h,020h,042h,04Ch,04Fh,043h,04Bh,053h,020h,04Ch
        db 045h,046h,054h,0Ah,00h,00h,00h,00h
