; Strings and constants of src/lib/ea/ea_debug.asm, in link order.
bits 32
%include "hockey.inc"
section s_C4034 progbits alloc noexec write align=1
global str_DBUGTXT, str_Wt2, str_FILES, str_DATES, str_TIMES, str_CLOSED, str_TIMES2, str_DateStampFmt
global str_2d02d02d, str_Asterisks, str_Fs, str_Jan2, str_Feb3, str_Mar2, str_Apr2, str_May3
global str_Jun2, str_Jul2, str_Aug2, str_Sep2, str_Oct2, str_Nov2, str_Dec2
str_DBUGTXT:                                    ; "DBUG??.TXT" string literal; used by DebugLogOpen
        db 044h,042h,055h,047h,03Fh,03Fh,02Eh,054h,058h,054h,00h,064h
str_Wt2:                                        ; "wt" string literal; used by DebugLogOpen
        db 077h,074h,00h,0Dh
str_FILES:                                      ; "FILE: %s\n" string literal; used by DebugLogOpen
        db 046h,049h,04Ch,045h,03Ah,020h,025h,073h,0Ah,00h,020h,020h
str_DATES:                                      ; "DATE: %s\n" string literal; used by DebugLogClose,
                                                ; DebugLogOpen
        db 044h,041h,054h,045h,03Ah,020h,025h,073h,0Ah,00h,020h,06Dh
str_TIMES:                                      ; "TIME: %s\n\n" string literal; used by DebugLogOpen
        db 054h,049h,04Dh,045h,03Ah,020h,025h,073h,0Ah,0Ah,00h,056h
str_CLOSED:                                     ; "\nCLOSED\n" string literal; used by DebugLogClose
        db 0Ah,043h,04Ch,04Fh,053h,045h,044h,0Ah,00h,069h,02Ch,020h
str_TIMES2:                                     ; "TIME: %s\n" string literal; used by DebugLogClose
        db 054h,049h,04Dh,045h,03Ah,020h,025h,073h,0Ah,00h,02Ch,020h
str_DateStampFmt:                               ; Date format string; used by FormatDateStamp
        db 025h,030h,032h,064h,02Dh,025h,033h,073h,02Dh,025h,030h,032h,064h,00h,020h,066h
str_2d02d02d:                                   ; string '%2d:%02d:%02d'; used by FormatDateStamp
        db 025h,032h,064h,03Ah,025h,030h,032h,064h,03Ah,025h,030h,032h,064h,00h,00h,00h
str_Asterisks:                                  ; Row of asterisks for the memory map; used by MemMapRulePtr
        db 02Ah,02Ah,02Ah,02Ah,02Ah,02Ah,02Ah,02Ah,02Ah,02Ah,02Ah,02Ah,02Ah,02Ah,02Ah,02Ah
        db 02Ah,02Ah,02Ah,02Ah,02Ah,02Ah,02Ah,02Ah,02Ah,02Ah,02Ah,02Ah,02Ah,02Ah,02Ah,02Ah
        db 02Ah,02Ah,02Ah,02Ah,02Ah,02Ah,02Ah,02Ah,00h,020h,02Ah,066h
str_Fs:                                         ; "%Fs" string literal; used by MonthNameTable
        db 025h,046h,073h,00h
str_Jan2:                                       ; "Jan" string literal; used by MonthNameTable
        db 04Ah,061h,06Eh,00h
str_Feb3:                                       ; "Feb" string literal; used by MonthNameTable
        db 046h,065h,062h,00h
str_Mar2:                                       ; "Mar" string literal; used by MonthNameTable
        db 04Dh,061h,072h,00h
str_Apr2:                                       ; "Apr" string literal; used by MonthNameTable
        db 041h,070h,072h,00h
str_May3:                                       ; "May" string literal; used by MonthNameTable
        db 04Dh,061h,079h,00h
str_Jun2:                                       ; "Jun" string literal; used by MonthNameTable
        db 04Ah,075h,06Eh,00h
str_Jul2:                                       ; "Jul" string literal; used by MonthNameTable
        db 04Ah,075h,06Ch,00h
str_Aug2:                                       ; "Aug" string literal; used by MonthNameTable
        db 041h,075h,067h,00h
str_Sep2:                                       ; "Sep" string literal; used by MonthNameTable
        db 053h,065h,070h,00h
str_Oct2:                                       ; "Oct" string literal; used by MonthNameTable
        db 04Fh,063h,074h,00h
str_Nov2:                                       ; "Nov" string literal; used by MonthNameTable
        db 04Eh,06Fh,076h,00h
str_Dec2:                                       ; "Dec" string literal; used by MonthNameTable
        db 044h,065h,063h,00h
