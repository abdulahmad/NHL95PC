; Initialised data of pc/file_dialogs (src/pc/file_dialogs).
bits 32
%include "hockey.inc"
section s_C6F78 progbits alloc noexec write align=1
extern exhfiles, lgfiles, pofiles
global fdlgshapes, fdlgfilelists, fdlgfilelists_e01, fdlgfilelists_e02, fdlgrects, str_ConfirmDeletionOfThe, str_ExhibitionGameCalled, str_LeagueCalled
global str_PlayOffSeriesCalled, delmsgbox
fdlgshapes:                                     ; open_but shape file handle; used by LoadDbDialogShapes,
                                                ; LoadFileDlgShapes, MenuOpenDatabase ...
        db 00h,00h,00h,00h
fdlgfilelists:                                  ; file dialog: file list of each tab (lgfiles, pofiles,
                                                ; exhfiles), by fdlgtab; used by DrawFileDlg,
                                                ; DrawFileDlgList_n1, DrawFileDlgTabs ...
        dd lgfiles
fdlgfilelists_e01:                              ; fdlgfilelists[1] (pofiles); used by RunFileDlg
        dd pofiles
fdlgfilelists_e02:                              ; fdlgfilelists[2] (exhfiles); used by RunFileDlg
        dd exhfiles
fdlgrects:                                      ; 16 hotspot rects (x0, y0, x1, y1); used by DrawFileDlg,
                                                ; DrawFileDlgList, DrawFileDlgList_n1 ...
        db 0Eh,00h,00h,00h
        db 033h,00h,00h,00h
        db 01Ah,00h,00h,00h
        db 03Dh,00h,00h,00h,0Eh,00h,00h,00h,094h,00h,00h,00h,01Ah,00h,00h,00h
        db 09Eh,00h,00h,00h,016h,00h,00h,00h,0ACh,00h,00h,00h,048h,00h,00h,00h
        db 0BCh,00h,00h,00h,05Dh,00h,00h,00h,0ACh,00h,00h,00h,08Fh,00h,00h,00h
        db 0BCh,00h,00h,00h,0A4h,00h,00h,00h,0ACh,00h,00h,00h,0D6h,00h,00h,00h
        db 0BCh,00h,00h,00h,099h,00h,00h,00h,038h,00h,00h,00h,0DFh,00h,00h,00h
        db 049h,00h,00h,00h,099h,00h,00h,00h,050h,00h,00h,00h,0DFh,00h,00h,00h
        db 061h,00h,00h,00h,099h,00h,00h,00h,068h,00h,00h,00h,0DFh,00h,00h,00h
        db 079h,00h,00h,00h
        db 0Fh,00h,00h,00h
        db 041h,00h,00h,00h
        db 019h,00h,00h,00h
        db 090h,00h,00h,00h
        db 081h,00h,00h,00h
        db 09h,00h,00h,00h
        db 0E4h,00h,00h,00h
        db 01Ah,00h,00h,00h
        db 025h,00h,00h,00h
        db 03Bh,00h,00h,00h
        db 082h,00h,00h,00h
        db 046h,00h,00h,00h,025h,00h,00h,00h,04Bh,00h,00h,00h,082h,00h,00h,00h
        db 056h,00h,00h,00h,025h,00h,00h,00h,05Bh,00h,00h,00h,082h,00h,00h,00h
        db 066h,00h,00h,00h,025h,00h,00h,00h,06Bh,00h,00h,00h,082h,00h,00h,00h
        db 076h,00h,00h,00h,025h,00h,00h,00h,07Bh,00h,00h,00h,082h,00h,00h,00h
        db 086h,00h,00h,00h,025h,00h,00h,00h,08Bh,00h,00h,00h,082h,00h,00h,00h
        db 096h,00h,00h,00h
str_ConfirmDeletionOfThe:                       ; "Confirm Deletion of the" string literal
        db 043h,06Fh,06Eh,066h,069h,072h,06Dh,020h,044h,065h,06Ch,065h,074h,069h,06Fh,06Eh
        db 020h,06Fh,066h,020h,074h,068h,065h,00h
str_ExhibitionGameCalled:                       ; string 'Exhibition Game Called:'; used by DeleteSavedGame
        db 045h,078h,068h,069h,062h,069h,074h,069h,06Fh,06Eh,020h,047h,061h,06Dh,065h,020h
        db 043h,061h,06Ch,06Ch,065h,064h,03Ah,00h
str_LeagueCalled:                               ; string 'League Called:'; used by DeleteSavedGame
        db 04Ch,065h,061h,067h,075h,065h,020h,043h,061h,06Ch,06Ch,065h,064h,03Ah,00h
str_PlayOffSeriesCalled:                        ; string 'Play-Off Series Called:'; used by DeleteSavedGame
        db 050h,06Ch,061h,079h,02Dh,04Fh,066h,066h,020h,053h,065h,072h,069h,065h,073h,020h
        db 043h,061h,06Ch,06Ch,065h,064h,03Ah,00h
delmsgbox:                                      ; DeleteSavedGame MessageBox args (title at +4); used by
                                                ; DeleteSavedGame
        dd str_ConfirmDeletionOfThe
        db 00h,00h,00h,00h
        db 00h,00h,00h,00h,00h
