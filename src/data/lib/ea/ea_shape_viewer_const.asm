; Strings and constants of src/lib/ea/ea_shape_viewer.asm, in link order.
bits 32
%include "hockey.inc"
section s_C4494 progbits alloc noexec write align=1
global str_ShapeFileIsInvalid, str_NumDPackedD, str_ThereAreNoShapes, str_44s05x, str_Bad, str_CxCy3d3d, str_NotDrawn, str_Bytes3dRows3d
global str_Un, str_Spacked, str_Packed, str_Unpacked, str_3d3d3d3dS, str_ShapeIsInvalidDraw, str_MEMSHPTXT, str_ErrorDumpingShapesList
global str_ShapeFileName0, str_ShapeFileSizeLd, str_NumberOfShapesD, str_44s66ld, str_Bytes3dRows3d2, str_XY3d3d, str_Newline, str_033d022X
global str_R022d, str_G022d, str_B022d, str_TwoDigitFmt, str_SCREEN2
str_ShapeFileIsInvalid:                         ; "Shape file is invalid. Work with it?" string literal; used
                                                ; by ShapeViewer
        db 053h,068h,061h,070h,065h,020h,066h,069h,06Ch,065h,020h,069h,073h,020h,069h,06Eh
        db 076h,061h,06Ch,069h,064h,02Eh,020h,020h,057h,06Fh,072h,06Bh,020h,077h,069h,074h
        db 068h,020h,069h,074h,03Fh,00h,032h,078h
str_NumDPackedD:                                ; "Num = %d, # packed = %d, # not packed = %d, # no shows =
                                                ; %d\n" string literal; used by ShapeViewer
        db 04Eh,075h,06Dh,020h,03Dh,020h,025h,064h,02Ch,020h,023h,020h,070h,061h,063h,06Bh
        db 065h,064h,020h,03Dh,020h,025h,064h,02Ch,020h,023h,020h,06Eh,06Fh,074h,020h,070h
        db 061h,063h,06Bh,065h,064h,020h,03Dh,020h,025h,064h,02Ch,020h,023h,020h,06Eh,06Fh
        db 020h,073h,068h,06Fh,077h,073h,020h,03Dh,020h,025h,064h,0Ah,00h,054h,049h,04Dh
str_ThereAreNoShapes:                           ; "There are no shapes that can be shown!" string literal;
                                                ; used by ShapeViewer
        db 054h,068h,065h,072h,065h,020h,061h,072h,065h,020h,06Eh,06Fh,020h,073h,068h,061h
        db 070h,065h,073h,020h,074h,068h,061h,074h,020h,063h,061h,06Eh,020h,062h,065h,020h
        db 073h,068h,06Fh,077h,06Eh,021h,00h,041h
str_44s05x:                                     ; "'%4.4s' %05x: " string literal; used by ShapeViewer
        db 027h,025h,034h,02Eh,034h,073h,027h,020h,025h,030h,035h,078h,03Ah,020h,00h,045h
str_Bad:                                        ; "Bad.\n" string literal; used by ShapeViewer
        db 042h,061h,064h,02Eh,0Ah,00h,075h,06Dh
str_CxCy3d3d:                                   ; "cx/cy = %3d/%3d - " string literal; used by ShapeViewer
        db 063h,078h,02Fh,063h,079h,020h,03Dh,020h,025h,033h,064h,02Fh,025h,033h,064h,020h
        db 02Dh,020h,00h,053h
str_NotDrawn:                                   ; "Not drawn.\n" string literal; used by ShapeViewer
        db 04Eh,06Fh,074h,020h,064h,072h,061h,077h,06Eh,02Eh,0Ah,00h
str_Bytes3dRows3d:                              ; "bytes = %3d, rows = %3d, x/y = %3d/%3d, cx/cy = %3d/%3d"
                                                ; string literal; used by ShapeInfo
        db 062h,079h,074h,065h,073h,020h,03Dh,020h,025h,033h,064h,02Ch,020h,072h,06Fh,077h
        db 073h,020h,03Dh,020h,025h,033h,064h,02Ch,020h,078h,02Fh,079h,020h,03Dh,020h,025h
        db 033h,064h,02Fh,025h,033h,064h,02Ch,020h,063h,078h,02Fh,063h,079h,020h,03Dh,020h
        db 025h,033h,064h,02Fh,025h,033h,064h,00h
str_Un:                                         ; "un" string literal; used by DumpShapesList, ShapeInfo
        db 075h,06Eh,00h,061h
str_Spacked:                                    ; " %spacked\n" string literal; used by DumpShapesList,
                                                ; ShapeInfo
        db 020h,025h,073h,070h,061h,063h,06Bh,065h,064h,0Ah,00h,023h
str_Packed:                                     ; "packed " string literal; used by ShapeInfo
        db 070h,061h,063h,06Bh,065h,064h,020h,020h,00h,020h,03Dh,020h
str_Unpacked:                                   ; "unpacked" string literal; used by ShapeInfo
        db 075h,06Eh,070h,061h,063h,06Bh,065h,064h,00h,065h,072h,065h
str_3d3d3d3dS:                                  ; string "%3d/%3d, %3d/%3d, %s"; used by ShapeInfo
        db 025h,033h,064h,02Fh,025h,033h,064h,02Ch,020h,025h,033h,064h,02Fh,025h,033h,064h
        db 02Ch,020h,025h,073h,00h,061h,06Eh,020h
str_ShapeIsInvalidDraw:                         ; "Shape is invalid. Draw it anyways?" string literal; used by
                                                ; ShapeInfo
        db 053h,068h,061h,070h,065h,020h,069h,073h,020h,069h,06Eh,076h,061h,06Ch,069h,064h
        db 02Eh,020h,020h,044h,072h,061h,077h,020h,069h,074h,020h,061h,06Eh,079h,077h,061h
        db 079h,073h,03Fh,00h
str_MEMSHPTXT:                                  ; "MEMSHP??.TXT" string literal; used by DumpShapesList
        db 04Dh,045h,04Dh,053h,048h,050h,03Fh,03Fh,02Eh,054h,058h,054h,00h,064h,020h,02Dh
str_ErrorDumpingShapesList:                     ; "Error Dumping Shapes List" string literal; used by
                                                ; DumpShapesList
        db 045h,072h,072h,06Fh,072h,020h,044h,075h,06Dh,070h,069h,06Eh,067h,020h,053h,068h
        db 061h,070h,065h,073h,020h,04Ch,069h,073h,074h,00h,02Ch,020h
str_ShapeFileName0:                             ; "Shape file name: %0.12s\n" string literal; used by
                                                ; DumpShapesList
        db 053h,068h,061h,070h,065h,020h,066h,069h,06Ch,065h,020h,06Eh,061h,06Dh,065h,03Ah
        db 020h,025h,030h,02Eh,031h,032h,073h,0Ah,00h,00h,00h,00h
str_ShapeFileSizeLd:                            ; "Shape file size: %ld\n" string literal; used by
                                                ; DumpShapesList
        db 053h,068h,061h,070h,065h,020h,066h,069h,06Ch,065h,020h,073h,069h,07Ah,065h,03Ah
        db 020h,025h,06Ch,064h,0Ah,00h,064h,0Ah
str_NumberOfShapesD:                            ; "Number of shapes: %d\n\n" string literal; used by
                                                ; DumpShapesList
        db 04Eh,075h,06Dh,062h,065h,072h,020h,06Fh,066h,020h,073h,068h,061h,070h,065h,073h
        db 03Ah,020h,025h,064h,0Ah,0Ah,00h,065h
str_44s66ld:                                    ; "'%-4.4s' @ %6.6ld, " string literal; used by DumpShapesList
        db 027h,025h,02Dh,034h,02Eh,034h,073h,027h,020h,040h,020h,025h,036h,02Eh,036h,06Ch
        db 064h,02Ch,020h,00h
str_Bytes3dRows3d2:                             ; "bytes = %3d, rows = %3d, " string literal; used by
                                                ; DumpShapesList
        db 062h,079h,074h,065h,073h,020h,03Dh,020h,025h,033h,064h,02Ch,020h,072h,06Fh,077h
        db 073h,020h,03Dh,020h,025h,033h,064h,02Ch,020h,00h,072h,061h
str_XY3d3d:                                     ; "x/y = %3d/%3d, cx/cy = %3d/%3d" string literal; used by
                                                ; DumpShapesList
        db 078h,02Fh,079h,020h,03Dh,020h,025h,033h,064h,02Fh,025h,033h,064h,02Ch,020h,063h
        db 078h,02Fh,063h,079h,020h,03Dh,020h,025h,033h,064h,02Fh,025h,033h,064h,00h,072h
str_Newline:                                    ; Newline; used by DumpShapesList
        db 0Ah,00h,072h,020h
str_033d022X:                                   ; "%03.3d (%02.2X)" string literal; used by PaletteViewer
        db 025h,030h,033h,02Eh,033h,064h,020h,028h,025h,030h,032h,02Eh,032h,058h,029h,00h
str_R022d:                                      ; "R=%02.2d" string literal; used by PaletteViewer
        db 052h,03Dh,025h,030h,032h,02Eh,032h,064h,00h,070h,065h,020h
str_G022d:                                      ; "G=%02.2d" string literal; used by PaletteViewer
        db 047h,03Dh,025h,030h,032h,02Eh,032h,064h,00h,00h,00h,00h
str_B022d:                                      ; "B=%02.2d" string literal; used by PaletteViewer
        db 042h,03Dh,025h,030h,032h,02Eh,032h,064h,00h,065h,020h,073h
str_TwoDigitFmt:                                ; Two-digit number format; used by PaletteViewerLabel
        db 025h,030h,032h,064h,00h,025h,06Ch,064h
str_SCREEN2:                                    ; "SCREEN??.*" string literal; used by SaveScreenshot
        db 053h,043h,052h,045h,045h,04Eh,03Fh,03Fh,02Eh,02Ah,00h,06Fh
