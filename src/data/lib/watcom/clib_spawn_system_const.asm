; Strings and constants of src/lib/watcom/clib_spawn_system.asm, in link order.
bits 32
%include "hockey.inc"
section s_C4AB4 progbits alloc noexec write align=1
global str_DotBackslash, str_Bat, str_Com, str_Exe, str_COMSPEC, str_CMD, str_COMMAND
str_DotBackslash:                               ; Current directory prefix used by spawnve
        db 02Eh,05Ch,00h
str_Bat:                                        ; ".bat" string literal; used by spawnve_
        db 02Eh,062h,061h,074h,00h
str_Com:                                        ; ".com" string literal; used by spawnve_
        db 02Eh,063h,06Fh,06Dh,00h
str_Exe:                                        ; ".exe" string literal; used by spawnve_
        db 02Eh,065h,078h,065h,00h
str_COMSPEC:                                    ; "COMSPEC" string literal; used by spawnve_
        db 043h,04Fh,04Dh,053h,050h,045h,043h,00h
str_CMD:                                        ; "CMD" string literal; used by spawnve_
        db 043h,04Dh,044h,00h
str_COMMAND:                                    ; "COMMAND" string literal; used by spawnve_
        db 043h,04Fh,04Dh,04Dh,041h,04Eh,044h,00h,00h,00h
