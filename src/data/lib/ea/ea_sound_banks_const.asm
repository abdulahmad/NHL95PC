; Strings and constants of src/lib/ea/ea_sound_banks.asm, in link order.
bits 32
%include "hockey.inc"
section s_C3FA4 progbits alloc noexec write align=1
global str_SCN, str_03sFF03dPAT, str_03sFF03dTIM, str_KMS2, str_CFG2, str_VHDR, str_EmptyExt
str_SCN:                                        ; "SCN" string literal; used by LoadMusicBank
        db 053h,043h,04Eh,00h
str_03sFF03dPAT:                                ; "%0.3sFF%03d.PAT" string literal; used by LoadMusicBank
        db 025h,030h,02Eh,033h,073h,046h,046h,025h,030h,033h,064h,02Eh,050h,041h,054h,00h
str_03sFF03dTIM:                                ; "%0.3sFF%03d.TIM" string literal; used by LoadMusicBank
        db 025h,030h,02Eh,033h,073h,046h,046h,025h,030h,033h,064h,02Eh,054h,049h,04Dh,00h
str_KMS2:                                       ; "KMS" string literal; used by LoadSample
        db 04Bh,04Dh,053h,00h
str_CFG2:                                       ; "CFG" string literal; used by LoadSample
        db 043h,046h,047h,00h
str_VHDR:                                       ; "VHDR" string literal; used by LoadDigiFile
        db 056h,048h,044h,052h,00h
str_EmptyExt:                                   ; Empty extension string; used by ReplaceFileExt
        db 00h,00h,00h
