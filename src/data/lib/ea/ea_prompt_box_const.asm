; Strings and constants of src/lib/ea/ea_prompt_box.asm, in link order.
bits 32
%include "hockey.inc"
section s_C47E8 progbits alloc noexec write align=1
global str_EXITTODOSY, str_PAUSEPRESSANYKEY
str_EXITTODOSY:                                 ; "EXIT TO DOS (Y/N)" string literal; used by AskExitToDos
        db 045h,058h,049h,054h,020h,054h,04Fh,020h,044h,04Fh,053h,020h,028h,059h,02Fh,04Eh
        db 029h,00h,069h,07Ah
str_PAUSEPRESSANYKEY:                           ; "PAUSE - PRESS ANY KEY TO RESUME" string literal; used by
                                                ; PauseUntilKey
        db 050h,041h,055h,053h,045h,020h,02Dh,020h,050h,052h,045h,053h,053h,020h,041h,04Eh
        db 059h,020h,04Bh,045h,059h,020h,054h,04Fh,020h,052h,045h,053h,055h,04Dh,045h,00h
