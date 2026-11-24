; Strings and constants of src/lib/ea/ea_snap_screen.asm, in link order.
bits 32
%include "hockey.inc"
section s_C4934 progbits alloc noexec write align=1
global str_SHAPE2, str_Snap, str_Pal31, str_Snap2, str_Error0, str_NoSuchFileOr, str_ArgumentListTooBig, str_ExecFormatError
global str_BadFileNumber, str_NotEnoughMemory, str_PermissionDenied, str_FileExists, str_CrossDeviceLink, str_InvalidArgument, str_FileTableOverflow, str_TooManyOpenFiles
global str_NoSpaceLeftOn, str_ArgumentTooLarge, str_ResultTooLarge, str_ResourceDeadlockWouldOccur
str_SHAPE2:                                     ; "SHAPE" string literal; used by SnapScreenToShape
        db 053h,048h,041h,050h,045h,00h,061h,072h
str_Snap:                                       ; "Snap" string literal; used by SnapScreenToShape
        db 053h,06Eh,061h,070h,00h,032h,02Ch,020h
str_Pal31:                                      ; "!pal" string literal; used by SnapScreenToShape
        db 021h,070h,061h,06Ch,00h,074h,020h,05Fh
str_Snap2:                                      ; "snap" string literal; used by SnapScreenToShape
        db 073h,06Eh,061h,070h,00h,00h,00h,00h
str_Error0:                                     ; "Error 0" string literal
        db 045h,072h,072h,06Fh,072h,020h,030h,00h
str_NoSuchFileOr:                               ; "No such file or directory" string literal
        db 04Eh,06Fh,020h,073h,075h,063h,068h,020h,066h,069h,06Ch,065h,020h,06Fh,072h,020h
        db 064h,069h,072h,065h,063h,074h,06Fh,072h,079h,00h
str_ArgumentListTooBig:                         ; "Argument list too big" string literal
        db 041h,072h,067h,075h,06Dh,065h,06Eh,074h,020h,06Ch,069h,073h,074h,020h,074h,06Fh
        db 06Fh,020h,062h,069h,067h,00h
str_ExecFormatError:                            ; "Exec format error" string literal
        db 045h,078h,065h,063h,020h,066h,06Fh,072h,06Dh,061h,074h,020h,065h,072h,072h,06Fh
        db 072h,00h
str_BadFileNumber:                              ; "Bad file number" string literal
        db 042h,061h,064h,020h,066h,069h,06Ch,065h,020h,06Eh,075h,06Dh,062h,065h,072h,00h
str_NotEnoughMemory:                            ; "Not enough memory" string literal
        db 04Eh,06Fh,074h,020h,065h,06Eh,06Fh,075h,067h,068h,020h,06Dh,065h,06Dh,06Fh,072h
        db 079h,00h
str_PermissionDenied:                           ; "Permission denied" string literal
        db 050h,065h,072h,06Dh,069h,073h,073h,069h,06Fh,06Eh,020h,064h,065h,06Eh,069h,065h
        db 064h,00h
str_FileExists:                                 ; "File exists" string literal
        db 046h,069h,06Ch,065h,020h,065h,078h,069h,073h,074h,073h,00h
str_CrossDeviceLink:                            ; "Cross-device link" string literal
        db 043h,072h,06Fh,073h,073h,02Dh,064h,065h,076h,069h,063h,065h,020h,06Ch,069h,06Eh
        db 06Bh,00h
str_InvalidArgument:                            ; "Invalid argument" string literal
        db 049h,06Eh,076h,061h,06Ch,069h,064h,020h,061h,072h,067h,075h,06Dh,065h,06Eh,074h
        db 00h
str_FileTableOverflow:                          ; "File table overflow" string literal
        db 046h,069h,06Ch,065h,020h,074h,061h,062h,06Ch,065h,020h,06Fh,076h,065h,072h,066h
        db 06Ch,06Fh,077h,00h
str_TooManyOpenFiles:                           ; "Too many open files" string literal
        db 054h,06Fh,06Fh,020h,06Dh,061h,06Eh,079h,020h,06Fh,070h,065h,06Eh,020h,066h,069h
        db 06Ch,065h,073h,00h
str_NoSpaceLeftOn:                              ; "No space left on device" string literal
        db 04Eh,06Fh,020h,073h,070h,061h,063h,065h,020h,06Ch,065h,066h,074h,020h,06Fh,06Eh
        db 020h,064h,065h,076h,069h,063h,065h,00h
str_ArgumentTooLarge:                           ; "Argument too large" string literal
        db 041h,072h,067h,075h,06Dh,065h,06Eh,074h,020h,074h,06Fh,06Fh,020h,06Ch,061h,072h
        db 067h,065h,00h
str_ResultTooLarge:                             ; "Result too large" string literal
        db 052h,065h,073h,075h,06Ch,074h,020h,074h,06Fh,06Fh,020h,06Ch,061h,072h,067h,065h
        db 00h
str_ResourceDeadlockWouldOccur:                 ; "Resource deadlock would occur" string literal
        db 052h,065h,073h,06Fh,075h,072h,063h,065h,020h,064h,065h,061h,064h,06Ch,06Fh,063h
        db 06Bh,020h,077h,06Fh,075h,06Ch,064h,020h,06Fh,063h,063h,075h,072h,00h
