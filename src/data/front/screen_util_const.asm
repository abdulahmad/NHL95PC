; Strings and constants of front/screen_util (src/front/screen_util), in link order.
bits 32
%include "hockey.inc"
section s_C0A80 progbits alloc noexec write align=1
global str_scrbrd1, str_LineCodes0, str_LineCodes1, str_LineCodes2, str_VisLineTags, str_HomeLineTags, str_Visp, str_Homp
global str_LineNames
str_scrbrd1:                                    ; string; used by LoadScoreboardGfx
        db 073h,063h,072h,062h,072h,064h,031h,00h
str_LineCodes0:                                 ; string "0000000100020003000400050006000700080009000 "; used
                                                ; by LoadScoreboardGfx
        db 030h,030h,030h,030h,030h,030h,030h,031h,030h,030h,030h,032h,030h,030h,030h,033h
        db 030h,030h,030h,034h,030h,030h,030h,035h,030h,030h,030h,036h,030h,030h,030h,037h
        db 030h,030h,030h,038h,030h,030h,030h,039h,030h,030h,030h,020h,00h
str_LineCodes1:                                 ; string "1000100110021003100410051006100710081009100 "; used
                                                ; by LoadScoreboardGfx
        db 031h,030h,030h,030h,031h,030h,030h,031h,031h,030h,030h,032h,031h,030h,030h,033h
        db 031h,030h,030h,034h,031h,030h,030h,035h,031h,030h,030h,036h,031h,030h,030h,037h
        db 031h,030h,030h,038h,031h,030h,030h,039h,031h,030h,030h,020h,00h
str_LineCodes2:                                 ; string "2000200120022003200420052006200720082009200 "; used
                                                ; by LoadScoreboardGfx
        db 032h,030h,030h,030h,032h,030h,030h,031h,032h,030h,030h,032h,032h,030h,030h,033h
        db 032h,030h,030h,034h,032h,030h,030h,035h,032h,030h,030h,036h,032h,030h,030h,037h
        db 032h,030h,030h,038h,032h,030h,030h,039h,032h,030h,030h,020h,00h
str_VisLineTags:                                ; string 'vlinvpp vpk '; used by LoadScoreboardGfx
        db 076h,06Ch,069h,06Eh,076h,070h,070h,020h,076h,070h,06Bh,020h,00h
str_HomeLineTags:                               ; string 'hlinhpp hpk '; used by LoadScoreboardGfx
        db 068h,06Ch,069h,06Eh,068h,070h,070h,020h,068h,070h,06Bh,020h,00h
str_Visp:                                       ; string 'visp'; used by LoadScoreboardGfx
        db 076h,069h,073h,070h,00h
str_Homp:                                       ; string 'homp'; used by LoadScoreboardGfx
        db 068h,06Fh,06Dh,070h,00h
str_LineNames:                                  ; string 'lin1lin2lin3lin4PP1 PP2 PK1 PK2 '; used by
                                                ; LoadScoreboardGfx
        db 06Ch,069h,06Eh,031h,06Ch,069h,06Eh,032h,06Ch,069h,06Eh,033h,06Ch,069h,06Eh,034h
        db 050h,050h,031h,020h,050h,050h,032h,020h,050h,04Bh,031h,020h,050h,04Bh,032h,020h
        db 00h
