; Strings and constants of src/lib/ea/ea_mem_viewer.asm, in link order.
bits 32
%include "hockey.inc"
section s_C4100 progbits alloc noexec write align=1
global str_CS44xDS, str_CS44xDS2, str_Used66xFree, str_Used7uFree7u, str_NAMESIZEADREND, str_IDXNAMESIZEADR, str_CharFmt, str_80s
global MemViewStrings, str_StrNewline, str_S_MemViewerDrawList, str_SPACE9x8s8s, str_SPACE9d8s8s, str_SPACE66x6, str_SPACE7d66s, str_MemListRowFmt
global str_1212s9d8s8s, str_33d1212s66x66s66s44x, str_MemBlockRowFmt, str_MEMMANAGER, str_X_DebugSprintf, str_044X00000000, str_One, str_SYSTEM
global str_SPACE3, str_HIGHMemoryBlock, str_LOWMemoryBlock, str_ConventionalMemory, str_RelocatableBlock, str_NonRelocatableBlock, str_ALIGNFlagIsSet, str_PRIORITY1d
global str_SequenceD, str_BlockIsPURGABLE, str_04x2, str_02x, str_Asterisk, str_SpaceChar, str_FourSpaces, str_FILES2
global str_DATES2, str_TIMES3, str_N, str_FF, str_HexmemdspOS, str_XxMMAPTXT, str_W_DumpMemoryMap, str_ErrorDumpingMemoryMap
str_CS44xDS:                                    ; "CS=%4.4x DS=%4.4x HW=%6.6x Pool=%6.6x " string literal;
                                                ; used by MemViewerDrawList
        db 043h,053h,03Dh,025h,034h,02Eh,034h,078h,020h,044h,053h,03Dh,025h,034h,02Eh,034h
        db 078h,020h,020h,048h,057h,03Dh,025h,036h,02Eh,036h,078h,020h,020h,050h,06Fh,06Fh
        db 06Ch,03Dh,025h,036h,02Eh,036h,078h,020h,00h,072h,020h,066h
str_CS44xDS2:                                   ; "CS=%4.4x DS=%4.4x HW=%-7u Pool=%-7u" string literal; used
                                                ; by MemViewerDrawList
        db 043h,053h,03Dh,025h,034h,02Eh,034h,078h,020h,044h,053h,03Dh,025h,034h,02Eh,034h
        db 078h,020h,020h,048h,057h,03Dh,025h,02Dh,037h,075h,020h,050h,06Fh,06Fh,06Ch,03Dh
        db 025h,02Dh,037h,075h,00h,00h,00h,00h
str_Used66xFree:                                ; "Used=%6.6x Free=%6.6x Largst=%6.6x " string literal; used
                                                ; by MemViewerDrawList
        db 055h,073h,065h,064h,03Dh,025h,036h,02Eh,036h,078h,020h,020h,046h,072h,065h,065h
        db 03Dh,025h,036h,02Eh,036h,078h,020h,020h,04Ch,061h,072h,067h,073h,074h,03Dh,025h
        db 036h,02Eh,036h,078h,020h,00h,02Ah,02Ah
str_Used7uFree7u:                               ; "Used=%-7u Free=%-7u Largst=%-7u" string literal; used by
                                                ; MemViewerDrawList
        db 055h,073h,065h,064h,03Dh,025h,02Dh,037h,075h,020h,046h,072h,065h,065h,03Dh,025h
        db 02Dh,037h,075h,020h,04Ch,061h,072h,067h,073h,074h,03Dh,025h,02Dh,037h,075h,00h
str_NAMESIZEADREND:                             ; " NAME SIZE ADR END " string literal; used by
                                                ; MemViewerDrawList
        db 020h,020h,020h,020h,04Eh,041h,04Dh,045h,020h,020h,020h,020h,020h,020h,053h,049h
        db 05Ah,045h,020h,020h,020h,020h,020h,020h,020h,041h,044h,052h,020h,020h,020h,020h
        db 020h,020h,045h,04Eh,044h,020h,020h,00h
str_IDXNAMESIZEADR:                             ; "IDX NAME SIZE ADR END FLAG" string literal; used by
                                                ; MemViewerDrawList
        db 049h,044h,058h,020h,020h,020h,020h,020h,04Eh,041h,04Dh,045h,020h,020h,020h,020h
        db 020h,020h,020h,053h,049h,05Ah,045h,020h,020h,020h,020h,041h,044h,052h,020h,020h
        db 020h,020h,045h,04Eh,044h,020h,020h,046h,04Ch,041h,047h,00h
str_CharFmt:                                    ; Character format; used by HexDumpRow, MemViewerDrawList
        db 025h,063h,00h,048h
str_80s:                                        ; string "%-80s"; used by HexDumpRow, MemViewerDrawList
        db 025h,02Dh,038h,030h,073h,00h,020h,050h
MemViewStrings:                                 ; used by DumpShapesList, HexDumpRow, MemViewerDrawList ...
        db 00h,00h,00h,00h
str_StrNewline:                                 ; Format: string then newline; used by DumpShapesList,
                                                ; MemViewerDrawList, WriteMemMap
        db 025h,073h,0Ah,00h
str_S_MemViewerDrawList:                        ; string "%s "; used by MemViewerDrawList
        db 025h,073h,0Ah,0Ah,00h,078h,020h,020h
str_SPACE9x8s8s:                                ; " SPACE %9x %8s %8s" string literal; used by
                                                ; MemViewerDrawList
        db 020h,020h,020h,020h,020h,053h,050h,041h,043h,045h,020h,020h,020h,025h,039h,078h
        db 020h,025h,038h,073h,020h,025h,038h,073h,00h,00h,02Ah,02Ah
str_SPACE9d8s8s:                                ; " SPACE %9d %8s %8s" string literal; used by
                                                ; MemViewerDrawList
        db 020h,020h,020h,020h,020h,053h,050h,041h,043h,045h,020h,020h,020h,025h,039h,064h
        db 020h,025h,038h,073h,020h,025h,038h,073h,00h,074h,03Dh,025h
str_SPACE66x6:                                  ; " SPACE %6.6x %6.6s %6.6s" string literal; used by
                                                ; MemViewerDrawList
        db 020h,020h,020h,020h,020h,020h,020h,053h,050h,041h,043h,045h,020h,020h,020h,020h
        db 020h,020h,025h,036h,02Eh,036h,078h,020h,025h,036h,02Eh,036h,073h,020h,025h,036h
        db 02Eh,036h,073h,00h
str_SPACE7d66s:                                 ; " SPACE %7d %6.6s %6.6s" string literal; used by
                                                ; MemViewerDrawList
        db 020h,020h,020h,020h,020h,020h,020h,053h,050h,041h,043h,045h,020h,020h,020h,020h
        db 020h,025h,037h,064h,020h,025h,036h,02Eh,036h,073h,020h,025h,036h,02Eh,036h,073h
        db 00h,020h,020h,041h
str_MemListRowFmt:                              ; Memory viewer list row format; used by MemViewerDrawList
        db 025h,02Dh,031h,032h,02Eh,031h,032h,073h,020h,025h,039h,078h,020h,025h,038h,073h
        db 020h,025h,038h,073h,00h,02Dh,038h,030h
str_1212s9d8s8s:                                ; string '%-12.12s %9d %8s %8s'; used by MemViewerDrawList
        db 025h,02Dh,031h,032h,02Eh,031h,032h,073h,020h,025h,039h,064h,020h,025h,038h,073h
        db 020h,025h,038h,073h,00h,00h,00h,00h
str_33d1212s66x66s66s44x:                       ; string '%3.3d %-12.12s %6.6x %6.6s %6.6s %4.4x'; used by
                                                ; MemViewerDrawList
        db 025h,033h,02Eh,033h,064h,020h,025h,02Dh,031h,032h,02Eh,031h,032h,073h,020h,020h
        db 025h,036h,02Eh,036h,078h,020h,025h,036h,02Eh,036h,073h,020h,025h,036h,02Eh,036h
        db 073h,020h,025h,034h,02Eh,034h,078h,00h
str_MemBlockRowFmt:                             ; Memory viewer block row format; used by MemViewerDrawList
        db 025h,033h,02Eh,033h,064h,020h,025h,02Dh,031h,032h,02Eh,031h,032h,073h,020h,025h
        db 037h,064h,020h,025h,036h,02Eh,036h,073h,020h,025h,036h,02Eh,036h,073h,020h,025h
        db 034h,02Eh,034h,078h,00h,041h,043h,045h
str_MEMMANAGER:                                 ; "MEM MANAGER" string literal; used by MemViewerDrawTitle
        db 04Dh,045h,04Dh,020h,04Dh,041h,04Eh,041h,047h,045h,052h,00h
str_X_DebugSprintf:                             ; string "%x"; used by DebugSprintf
        db 025h,078h,00h,036h
str_044X00000000:                               ; "%04.4X (0000 0000 0000 0000)" string literal; used by
                                                ; MemViewerBlockInfo
        db 025h,030h,034h,02Eh,034h,058h,020h,028h,030h,030h,030h,030h,020h,030h,030h,030h
        db 030h,020h,030h,030h,030h,030h,020h,030h,030h,030h,030h,029h,00h,025h,036h,02Eh
str_One:                                        ; String 1; used by MemViewerBlockInfo
        db 031h,00h,020h,025h
str_SYSTEM:                                     ; " SYSTEM " string literal; used by MemViewerBlockInfo
        db 020h,053h,059h,053h,054h,045h,04Dh,020h,00h,02Dh,031h,032h
str_SPACE3:                                     ; " SPACE " string literal; used by MemViewerBlockInfo
        db 020h,053h,050h,041h,043h,045h,020h,00h
str_HIGHMemoryBlock:                            ; "HIGH memory block" string literal; used by
                                                ; MemViewerBlockInfo
        db 048h,049h,047h,048h,020h,06Dh,065h,06Dh,06Fh,072h,079h,020h,062h,06Ch,06Fh,063h
        db 06Bh,00h,00h,00h
str_LOWMemoryBlock:                             ; "LOW memory block" string literal; used by
                                                ; MemViewerBlockInfo
        db 04Ch,04Fh,057h,020h,06Dh,065h,06Dh,06Fh,072h,079h,020h,062h,06Ch,06Fh,063h,06Bh
        db 00h,036h,02Eh,036h
str_ConventionalMemory:                         ; "Conventional memory" string literal; used by
                                                ; MemViewerBlockInfo
        db 043h,06Fh,06Eh,076h,065h,06Eh,074h,069h,06Fh,06Eh,061h,06Ch,020h,06Dh,065h,06Dh
        db 06Fh,072h,079h,00h
str_RelocatableBlock:                           ; "Relocatable block" string literal; used by
                                                ; MemViewerBlockInfo
        db 052h,065h,06Ch,06Fh,063h,061h,074h,061h,062h,06Ch,065h,020h,062h,06Ch,06Fh,063h
        db 06Bh,00h,020h,025h
str_NonRelocatableBlock:                        ; "Non-Relocatable block" string literal; used by
                                                ; MemViewerBlockInfo
        db 04Eh,06Fh,06Eh,02Dh,052h,065h,06Ch,06Fh,063h,061h,074h,061h,062h,06Ch,065h,020h
        db 062h,06Ch,06Fh,063h,06Bh,00h,04Dh,020h
str_ALIGNFlagIsSet:                             ; "ALIGN flag is set" string literal; used by
                                                ; MemViewerBlockInfo
        db 041h,04Ch,049h,047h,04Eh,020h,066h,06Ch,061h,067h,020h,069h,073h,020h,073h,065h
        db 074h,00h,020h,028h
str_PRIORITY1d:                                 ; "PRIORITY #%1d" string literal; used by MemViewerBlockInfo
        db 050h,052h,049h,04Fh,052h,049h,054h,059h,020h,023h,025h,031h,064h,00h,020h,030h
str_SequenceD:                                  ; "Sequence #%d" string literal; used by MemViewerBlockInfo
        db 053h,065h,071h,075h,065h,06Eh,063h,065h,020h,023h,025h,064h,00h,053h,059h,053h
str_BlockIsPURGABLE:                            ; "Block is PURGABLE" string literal; used by
                                                ; MemViewerBlockInfo
        db 042h,06Ch,06Fh,063h,06Bh,020h,069h,073h,020h,050h,055h,052h,047h,041h,042h,04Ch
        db 045h,00h,047h,048h
str_04x2:                                       ; string '%04x '; used by HexDumpRow
        db 025h,030h,034h,078h,020h,020h,020h,00h
str_02x:                                        ; string '%02x'; used by HexDumpRow
        db 025h,030h,032h,078h,00h,00h,00h,00h
str_Asterisk:                                   ; One asterisk; used by HexDumpRow
        db 02Ah,00h,057h,020h
str_SpaceChar:                                  ; One space; used by HexDumpRow
        db 020h,00h,06Dh,06Fh
str_FourSpaces:                                 ; Four spaces; used by HexDumpRow
        db 020h,020h,020h,020h,00h,06Fh,063h,06Bh
str_FILES2:                                     ; "* FILE: %s\n" string literal; used by DumpShapesList,
                                                ; WriteMemMap
        db 02Ah,020h,046h,049h,04Ch,045h,03Ah,020h,025h,073h,0Ah,00h
str_DATES2:                                     ; "* DATE: %s\n" string literal; used by DumpShapesList,
                                                ; WriteMemMap
        db 02Ah,020h,044h,041h,054h,045h,03Ah,020h,025h,073h,0Ah,00h
str_TIMES3:                                     ; "* TIME: %s\n" string literal; used by DumpShapesList,
                                                ; WriteMemMap
        db 02Ah,020h,054h,049h,04Dh,045h,03Ah,020h,025h,073h,0Ah,00h
str_N:                                          ; Letter N; used by WriteMemMap
        db 04Eh,00h,06Fh,063h
str_FF:                                         ; "FF" string literal; used by WriteMemMap
        db 046h,046h,00h,025h
str_HexmemdspOS:                                ; "hexmemdsp = O%s\n\n" string literal; used by WriteMemMap
        db 068h,065h,078h,06Dh,065h,06Dh,064h,073h,070h,020h,03Dh,020h,04Fh,025h,073h,0Ah
        db 0Ah,00h,06Fh,063h
str_XxMMAPTXT:                                  ; "xxMMAP??.TXT" string literal; used by DumpMemoryMap
        db 078h,078h,04Dh,04Dh,041h,050h,03Fh,03Fh,02Eh,054h,058h,054h,00h,067h,020h,069h
str_W_DumpMemoryMap:                            ; string "w"; used by DumpMemoryMap, DumpShapesList
        db 077h,00h,073h,065h
str_ErrorDumpingMemoryMap:                      ; "Error Dumping Memory Map" string literal; used by
                                                ; DumpMemoryMap
        db 045h,072h,072h,06Fh,072h,020h,044h,075h,06Dh,070h,069h,06Eh,067h,020h,04Dh,065h
        db 06Dh,06Fh,072h,079h,020h,04Dh,061h,070h,00h,06Eh,063h,065h
