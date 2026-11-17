; Memory manager messages: low memory, high memory, and a block that could not be released.
bits 32
%include "hockey.inc"
section s_C3B98 progbits alloc noexec write align=1
global str_LOWMEM, str_HIGHMEM, str_GAP, str_ReleaseMemoryNotFound, str_ReservememINVALIDSIZE, str_ReservememOUTOFMEMORY, str_ReservememOUTOFMEMORY2, str_ReservememINVALIDTYPEFLAGS
global str_ResizememINVALIDSIZE, str_ResizememblockNOROOMTO, str_FindmemblockBLOCKNOTFOUND, str_GetmemblockNOMEMORYBLOCKS, str_InitmemmanINSUFFICIENTROW, str_EavesaCom, str_CUtilEavesaCom, str_InitgraphicsEAVESACOM
global str_CEavesaDat, str_InitgraphicsNEWVERSIONOF, str_VESA, str_InitgraphicsINITMEMMAN, str_InitgraphicsINVALIDSCREEN, str_VESAVideoBiosDriver, str_AddtimerLISTFULL, str_SUBWINDOW
global str_SubwindowdefadrOUTOFROW, str_SCN, str_03sFF03dPAT, str_03sFF03dTIM, str_KMS2, str_CFG2, str_VHDR, str_SavefileblockaOPENFAILEDFOR
global str_DBUGTXT, str_FILES, str_DATES, str_TIMES, str_CLOSED, str_TIMES2, str_DateStampFmt, str_2d02d02d
global str_CS44xDS, str_CS44xDS2, str_Used66xFree, str_Used7uFree7u, str_NAMESIZEADREND, str_IDXNAMESIZEADR, str_80s, str_StrNewline
global str_S_MemViewerDrawList, str_SPACE9x8s8s, str_SPACE9d8s8s, str_SPACE66x6, str_SPACE7d66s, str_MemListRowFmt, str_1212s9d8s8s, str_33d1212s66x66s66s44x
global str_MemBlockRowFmt, str_MEMMANAGER, str_044X00000000, str_SYSTEM, str_SPACE3, str_HIGHMemoryBlock, str_LOWMemoryBlock, str_ConventionalMemory
global str_RelocatableBlock, str_NonRelocatableBlock, str_ALIGNFlagIsSet, str_PRIORITY1d, str_SequenceD, str_BlockIsPURGABLE, str_04x2, str_02x
global str_FourSpaces, str_FILES2, str_DATES2, str_TIMES3, str_HexmemdspOS, str_XxMMAPTXT, str_ErrorDumpingMemoryMap, str_ShapeFileIsInvalid
global str_NumDPackedD, str_ThereAreNoShapes, str_44s05x, str_Bad, str_CxCy3d3d, str_NotDrawn, str_Bytes3dRows3d, str_Spacked
global str_Packed, str_Unpacked, str_3d3d3d3dS, str_ShapeIsInvalidDraw, str_MEMSHPTXT, str_ErrorDumpingShapesList, str_ShapeFileName0, str_ShapeFileSizeLd
global str_NumberOfShapesD, str_44s66ld, str_Bytes3dRows3d2, str_XY3d3d, str_033d022X, str_R022d, str_G022d, str_B022d
global str_TwoDigitFmt, str_SCREEN2, str_DateTimeFmt, str_2d02d02d2, str_FrameRate3dFrames, str_Width3dHeight3d, str_Colours3d1stColour, str_Mvipal
global str_DATABUFFER, str_Copyright, str_UnpackINVALIDPACKCODE, str_EXITTODOSY, str_PAUSEPRESSANYKEY, str_RemovewindowROWSPACE, str_FshVshQfsQvs, str_Vsh
global str_Qvs, str_MCGAWINDOW, str_WindowdefOUTOFMEMORY, str_WindowdefBADBLOCK, str_WindowdefadrOUTOFROW, str_Unpackf, str_Unpacking, str_SHAPE2
global str_Snap, str_Pal31, str_Snap2, str_UnknownError, str_BLASTER, str_PAT, str_ULTRADIR, str_MIDI
global str_EmptyExt, str_Jan, str_Feb2, str_Mar, str_Apr, str_May2, str_Jun, str_Jul
global str_Aug, str_Sep, str_Oct, str_Nov, str_Dec, str_Wt2, str_Asterisks, str_Fs
global str_Jan2, str_Feb3, str_Mar2, str_Apr2, str_May3, str_Jun2, str_Jul2, str_Aug2
global str_Sep2, str_Oct2, str_Nov2, str_Dec2, str_CharFmt, MemViewStrings, str_X_DebugSprintf, str_One
global str_Asterisk, str_SpaceChar, str_N, str_FF, str_W_DumpMemoryMap, str_Un, str_Newline, str_ColonSpace
global str_EACSNDFLIBJul28, str_Fsh, str_3sh, str_SHPI, str_SHPM, str_Error0, str_NoSuchFileOr, str_ArgumentListTooBig
global str_ExecFormatError, str_BadFileNumber, str_NotEnoughMemory, str_PermissionDenied, str_FileExists, str_CrossDeviceLink, str_InvalidArgument, str_FileTableOverflow
global str_TooManyOpenFiles, str_NoSpaceLeftOn, str_ArgumentTooLarge, str_ResultTooLarge, str_ResourceDeadlockWouldOccur
str_LOWMEM:                                     ; "LOW MEM" string literal; used by InitMemList
        db 04Ch,04Fh,057h,020h,04Dh,045h,04Dh,00h
str_HIGHMEM:                                    ; "HIGH MEM" string literal; used by AddHighMemList,
                                                ; InitMemList
        db 048h,049h,047h,048h,020h,04Dh,045h,04Dh,00h,020h,020h,020h
str_GAP:                                        ; "GAP" string literal; used by AddHighMemList
        db 047h,041h,050h,00h
str_ReleaseMemoryNotFound:                      ; "Release Memory Not Found\n" string literal; used by
                                                ; FindMemListBlock
        db 052h,065h,06Ch,065h,061h,073h,065h,020h,04Dh,065h,06Dh,06Fh,072h,079h,020h,04Eh
        db 06Fh,074h,020h,046h,06Fh,075h,06Eh,064h,0Ah,00h,065h,02Ch
str_ReservememINVALIDSIZE:                      ; "reservemem - INVALID SIZE REQUESTED\nrequested: %ld
                                                ; available: %ld\n" string literal; used by reservemem
        db 072h,065h,073h,065h,072h,076h,065h,06Dh,065h,06Dh,020h,02Dh,020h,049h,04Eh,056h
        db 041h,04Ch,049h,044h,020h,053h,049h,05Ah,045h,020h,052h,045h,051h,055h,045h,053h
        db 054h,045h,044h,0Ah,072h,065h,071h,075h,065h,073h,074h,065h,064h,03Ah,020h,025h
        db 06Ch,064h,020h,061h,076h,061h,069h,06Ch,061h,062h,06Ch,065h,03Ah,020h,025h,06Ch
        db 064h,0Ah,00h,072h
str_ReservememOUTOFMEMORY:                      ; "reservemem - OUT OF MEMORY\nrequested: %ld available:
                                                ; %ld\n" string literal; used by reservemem
        db 072h,065h,073h,065h,072h,076h,065h,06Dh,065h,06Dh,020h,02Dh,020h,04Fh,055h,054h
        db 020h,04Fh,046h,020h,04Dh,045h,04Dh,04Fh,052h,059h,0Ah,072h,065h,071h,075h,065h
        db 073h,074h,065h,064h,03Ah,020h,025h,06Ch,064h,020h,061h,076h,061h,069h,06Ch,061h
        db 062h,06Ch,065h,03Ah,020h,025h,06Ch,064h,0Ah,00h,00h,00h
str_ReservememOUTOFMEMORY2:                     ; "reservemem - OUT OF MEMORY\nrequested: %ld available:
                                                ; %ld\n" string literal; used by reservemem
        db 072h,065h,073h,065h,072h,076h,065h,06Dh,065h,06Dh,020h,02Dh,020h,04Fh,055h,054h
        db 020h,04Fh,046h,020h,04Dh,045h,04Dh,04Fh,052h,059h,0Ah,072h,065h,071h,075h,065h
        db 073h,074h,065h,064h,03Ah,020h,025h,06Ch,064h,020h,061h,076h,061h,069h,06Ch,061h
        db 062h,06Ch,065h,03Ah,020h,025h,06Ch,064h,0Ah,00h,065h,06Dh
str_ReservememINVALIDTYPEFLAGS:                 ; "reservemem - INVALID TYPE FLAGS (%04x)\n" string literal;
                                                ; used by reservemem
        db 072h,065h,073h,065h,072h,076h,065h,06Dh,065h,06Dh,020h,02Dh,020h,049h,04Eh,056h
        db 041h,04Ch,049h,044h,020h,054h,059h,050h,045h,020h,046h,04Ch,041h,047h,053h,020h
        db 028h,025h,030h,034h,078h,029h,0Ah,00h
str_ResizememINVALIDSIZE:                       ; "resizemem - INVALID SIZE REQUESTED\nrequested: %ld
                                                ; available: %ld\n" string literal; used by ResizeMemBlock
        db 072h,065h,073h,069h,07Ah,065h,06Dh,065h,06Dh,020h,02Dh,020h,049h,04Eh,056h,041h
        db 04Ch,049h,044h,020h,053h,049h,05Ah,045h,020h,052h,045h,051h,055h,045h,053h,054h
        db 045h,044h,0Ah,072h,065h,071h,075h,065h,073h,074h,065h,064h,03Ah,020h,025h,06Ch
        db 064h,020h,061h,076h,061h,069h,06Ch,061h,062h,06Ch,065h,03Ah,020h,025h,06Ch,064h
        db 0Ah,00h,06Ch,061h
str_ResizememblockNOROOMTO:                     ; "resizememblock - NO ROOM TO RESIZE\nrequested: %ld
                                                ; available: %ld\n" string literal; used by ResizeMemBlock
        db 072h,065h,073h,069h,07Ah,065h,06Dh,065h,06Dh,062h,06Ch,06Fh,063h,06Bh,020h,02Dh
        db 020h,04Eh,04Fh,020h,052h,04Fh,04Fh,04Dh,020h,054h,04Fh,020h,052h,045h,053h,049h
        db 05Ah,045h,0Ah,072h,065h,071h,075h,065h,073h,074h,065h,064h,03Ah,020h,025h,06Ch
        db 064h,020h,061h,076h,061h,069h,06Ch,061h,062h,06Ch,065h,03Ah,020h,025h,06Ch,064h
        db 0Ah,00h,061h,062h
str_FindmemblockBLOCKNOTFOUND:                  ; "findmemblock - BLOCK NOT FOUND (%p)\n" string literal; used
                                                ; by findmemblock
        db 066h,069h,06Eh,064h,06Dh,065h,06Dh,062h,06Ch,06Fh,063h,06Bh,020h,02Dh,020h,042h
        db 04Ch,04Fh,043h,04Bh,020h,04Eh,04Fh,054h,020h,046h,04Fh,055h,04Eh,044h,020h,028h
        db 025h,070h,029h,0Ah,00h,046h,04Ch,041h
str_GetmemblockNOMEMORYBLOCKS:                  ; "getmemblock - NO MEMORY BLOCKS LEFT\n" string literal; used
                                                ; by getmemblock
        db 067h,065h,074h,06Dh,065h,06Dh,062h,06Ch,06Fh,063h,06Bh,020h,02Dh,020h,04Eh,04Fh
        db 020h,04Dh,045h,04Dh,04Fh,052h,059h,020h,042h,04Ch,04Fh,043h,04Bh,053h,020h,04Ch
        db 045h,046h,054h,0Ah,00h,00h,00h,00h
str_InitmemmanINSUFFICIENTROW:                  ; "initmemman - INSUFFICIENT ROW TABLE SPACE\n" string
                                                ; literal; used by initmemman
        db 069h,06Eh,069h,074h,06Dh,065h,06Dh,06Dh,061h,06Eh,020h,02Dh,020h,049h,04Eh,053h
        db 055h,046h,046h,049h,043h,049h,045h,04Eh,054h,020h,052h,04Fh,057h,020h,054h,041h
        db 042h,04Ch,045h,020h,053h,050h,041h,043h,045h,0Ah,00h,00h
str_EavesaCom:                                  ; "eavesa.com" string literal; used by ProbeVesa
        db 065h,061h,076h,065h,073h,061h,02Eh,063h,06Fh,06Dh,00h,04Dh
str_CUtilEavesaCom:                             ; "c:\util\eavesa.com" string literal; used by ProbeVesa
        db 063h,03Ah,05Ch,075h,074h,069h,06Ch,05Ch,065h,061h,076h,065h,073h,061h,02Eh,063h
        db 06Fh,06Dh,00h,06Ch
str_InitgraphicsEAVESACOM:                      ; "initgraphics - EAVESA.COM REQUIRED IN PATH.\nPlease copy
                                                ; EAVESA.COM to" string literal; used by ProbeVesa
        db 069h,06Eh,069h,074h,067h,072h,061h,070h,068h,069h,063h,073h,020h,02Dh,020h,045h
        db 041h,056h,045h,053h,041h,02Eh,043h,04Fh,04Dh,020h,052h,045h,051h,055h,049h,052h
        db 045h,044h,020h,049h,04Eh,020h,050h,041h,054h,048h,02Eh,0Ah,050h,06Ch,065h,061h
        db 073h,065h,020h,063h,06Fh,070h,079h,020h,045h,041h,056h,045h,053h,041h,02Eh,043h
        db 04Fh,04Dh,020h,074h,06Fh,020h,079h,06Fh,075h,072h,020h,073h,079h,073h,074h,065h
        db 06Dh,02Eh,0Ah,00h
str_CEavesaDat:                                 ; "c:\eavesa.dat" string literal; used by ProbeVesa
        db 063h,03Ah,05Ch,065h,061h,076h,065h,073h,061h,02Eh,064h,061h,074h,00h,074h,020h
str_InitgraphicsNEWVERSIONOF:                   ; "initgraphics - NEW VERSION OF EAVESA.COM REQUIRED.\nPlease
                                                ; install EAV" string literal; used by ProbeVesa
        db 069h,06Eh,069h,074h,067h,072h,061h,070h,068h,069h,063h,073h,020h,02Dh,020h,04Eh
        db 045h,057h,020h,056h,045h,052h,053h,049h,04Fh,04Eh,020h,04Fh,046h,020h,045h,041h
        db 056h,045h,053h,041h,02Eh,043h,04Fh,04Dh,020h,052h,045h,051h,055h,049h,052h,045h
        db 044h,02Eh,0Ah,050h,06Ch,065h,061h,073h,065h,020h,069h,06Eh,073h,074h,061h,06Ch
        db 06Ch,020h,045h,041h,056h,045h,053h,041h,02Eh,043h,04Fh,04Dh,020h,061h,06Eh,064h
        db 020h,072h,065h,072h,075h,06Eh,02Eh,0Ah,00h,069h,074h,067h
str_VESA:                                       ; "VESA" string literal; used by ProbeVesa
        db 056h,045h,053h,041h,00h,063h,073h,020h
str_InitgraphicsINITMEMMAN:                     ; "initgraphics - INITMEMMAN REQUIRED BEFORE INITGRAPHICS\n"
                                                ; string literal; used by initgraphics
        db 069h,06Eh,069h,074h,067h,072h,061h,070h,068h,069h,063h,073h,020h,02Dh,020h,049h
        db 04Eh,049h,054h,04Dh,045h,04Dh,04Dh,041h,04Eh,020h,052h,045h,051h,055h,049h,052h
        db 045h,044h,020h,042h,045h,046h,04Fh,052h,045h,020h,049h,04Eh,049h,054h,047h,052h
        db 041h,050h,048h,049h,043h,053h,0Ah,00h
str_InitgraphicsINVALIDSCREEN:                  ; "initgraphics - INVALID SCREEN SIZE (%d,%d)\n" string
                                                ; literal; used by initgraphics
        db 069h,06Eh,069h,074h,067h,072h,061h,070h,068h,069h,063h,073h,020h,02Dh,020h,049h
        db 04Eh,056h,041h,04Ch,049h,044h,020h,053h,043h,052h,045h,045h,04Eh,020h,053h,049h
        db 05Ah,045h,020h,028h,025h,064h,02Ch,025h,064h,029h,0Ah,00h
str_VESAVideoBiosDriver:                        ; "VESA video bios driver required.\nPlease install a driver
                                                ; for your vid" string literal; used by initgraphics
        db 056h,045h,053h,041h,020h,076h,069h,064h,065h,06Fh,020h,062h,069h,06Fh,073h,020h
        db 064h,072h,069h,076h,065h,072h,020h,072h,065h,071h,075h,069h,072h,065h,064h,02Eh
        db 0Ah,050h,06Ch,065h,061h,073h,065h,020h,069h,06Eh,073h,074h,061h,06Ch,06Ch,020h
        db 061h,020h,064h,072h,069h,076h,065h,072h,020h,066h,06Fh,072h,020h,079h,06Fh,075h
        db 072h,020h,076h,069h,064h,065h,06Fh,020h,063h,061h,072h,064h,020h,061h,06Eh,064h
        db 020h,072h,065h,072h,075h,06Eh,02Eh,0Ah,00h,00h,00h,00h
str_AddtimerLISTFULL:                           ; "addtimer - LIST FULL\n" string literal; used by addtimer
        db 061h,064h,064h,074h,069h,06Dh,065h,072h,020h,02Dh,020h,04Ch,049h,053h,054h,020h
        db 046h,055h,04Ch,04Ch,0Ah,00h,00h,00h
str_SUBWINDOW:                                  ; "SUBWINDOW" string literal; used by subwindowdefadr
        db 053h,055h,042h,057h,049h,04Eh,044h,04Fh,057h,00h,064h,020h
str_SubwindowdefadrOUTOFROW:                    ; "subwindowdefadr - OUT OF ROW SPACE\n" string literal; used
                                                ; by subwindowdefadr
        db 073h,075h,062h,077h,069h,06Eh,064h,06Fh,077h,064h,065h,066h,061h,064h,072h,020h
        db 02Dh,020h,04Fh,055h,054h,020h,04Fh,046h,020h,052h,04Fh,057h,020h,053h,050h,041h
        db 043h,045h,0Ah,00h
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
str_SavefileblockaOPENFAILEDFOR:                ; "savefileblocka - OPEN FAILED FOR FILE <%s>\n" string
                                                ; literal; used by savefileblocka
        db 073h,061h,076h,065h,066h,069h,06Ch,065h,062h,06Ch,06Fh,063h,06Bh,061h,020h,02Dh
        db 020h,04Fh,050h,045h,04Eh,020h,046h,041h,049h,04Ch,045h,044h,020h,046h,04Fh,052h
        db 020h,046h,049h,04Ch,045h,020h,03Ch,025h,073h,03Eh,0Ah,00h
str_Jan:                                        ; "Jan" string literal
        db 04Ah,061h,06Eh,00h
str_Feb2:                                       ; "Feb" string literal
        db 046h,065h,062h,00h
str_Mar:                                        ; "Mar" string literal
        db 04Dh,061h,072h,00h
str_Apr:                                        ; "Apr" string literal
        db 041h,070h,072h,00h
str_May2:                                       ; "May" string literal
        db 04Dh,061h,079h,00h
str_Jun:                                        ; "Jun" string literal
        db 04Ah,075h,06Eh,00h
str_Jul:                                        ; "Jul" string literal
        db 04Ah,075h,06Ch,00h
str_Aug:                                        ; "Aug" string literal
        db 041h,075h,067h,00h
str_Sep:                                        ; "Sep" string literal
        db 053h,065h,070h,00h
str_Oct:                                        ; "Oct" string literal
        db 04Fh,063h,074h,00h
str_Nov:                                        ; "Nov" string literal
        db 04Eh,06Fh,076h,00h
str_Dec:                                        ; "Dec" string literal
        db 044h,065h,063h,00h
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
str_DateTimeFmt:                                ; Date format string used by FormatDateTime
        db 025h,030h,032h,064h,02Dh,025h,033h,073h,02Dh,025h,030h,032h,064h,00h,00h,065h
str_2d02d02d2:                                  ; string '%2d:%02d:%02d'; used by FormatDateTime
        db 025h,032h,064h,03Ah,025h,030h,032h,064h,03Ah,025h,030h,032h,064h,00h,00h,00h
str_ColonSpace:                                 ; Colon and space printed by perror; used by perror_
        db 03Ah,020h,00h,00h
str_FrameRate3dFrames:                          ; "Frame Rate: %3d Frames: %3d Block Size: %3d\n" string
                                                ; literal; used by MviPrintInfo
        db 046h,072h,061h,06Dh,065h,020h,052h,061h,074h,065h,03Ah,020h,025h,033h,064h,020h
        db 046h,072h,061h,06Dh,065h,073h,03Ah,020h,025h,033h,064h,020h,042h,06Ch,06Fh,063h
        db 06Bh,020h,053h,069h,07Ah,065h,03Ah,020h,025h,033h,064h,0Ah,00h,06Dh,065h,02Ch
str_Width3dHeight3d:                            ; "Width: %3d Height: %3d\n" string literal; used by
                                                ; MviPrintInfo
        db 057h,069h,064h,074h,068h,03Ah,020h,025h,033h,064h,020h,020h,020h,020h,020h,020h
        db 048h,065h,069h,067h,068h,074h,03Ah,020h,025h,033h,064h,0Ah,00h,063h,064h,065h
str_Colours3d1stColour:                         ; "Colours: %3d 1st Colour: %3d\n" string literal; used by
                                                ; MviPrintInfo
        db 043h,06Fh,06Ch,06Fh,075h,072h,073h,03Ah,020h,025h,033h,064h,020h,020h,020h,020h
        db 031h,073h,074h,020h,043h,06Fh,06Ch,06Fh,075h,072h,03Ah,020h,025h,033h,064h,0Ah
        db 00h,066h,069h,072h
str_Mvipal:                                     ; "mvipal" string literal; used by MviLoadPalette
        db 06Dh,076h,069h,070h,061h,06Ch,00h,020h
str_DATABUFFER:                                 ; "DATABUFFER" string literal; used by MviOpen
        db 044h,041h,054h,041h,042h,055h,046h,046h,045h,052h,00h,00h
str_Copyright:                                  ; "Copyright" string literal; used by SkipCopyrightHeader
        db 043h,06Fh,070h,079h,072h,069h,067h,068h,074h,00h,020h,066h
str_UnpackINVALIDPACKCODE:                      ; "unpack - INVALID PACK CODE (%x)\n" string literal; used by
                                                ; unpack
        db 075h,06Eh,070h,061h,063h,06Bh,020h,02Dh,020h,049h,04Eh,056h,041h,04Ch,049h,044h
        db 020h,050h,041h,043h,04Bh,020h,043h,04Fh,044h,045h,020h,028h,025h,078h,029h,0Ah
        db 00h,00h,00h,00h
str_EXITTODOSY:                                 ; "EXIT TO DOS (Y/N)" string literal; used by AskExitToDos
        db 045h,058h,049h,054h,020h,054h,04Fh,020h,044h,04Fh,053h,020h,028h,059h,02Fh,04Eh
        db 029h,00h,069h,07Ah
str_PAUSEPRESSANYKEY:                           ; "PAUSE - PRESS ANY KEY TO RESUME" string literal; used by
                                                ; PauseUntilKey
        db 050h,041h,055h,053h,045h,020h,02Dh,020h,050h,052h,045h,053h,053h,020h,041h,04Eh
        db 059h,020h,04Bh,045h,059h,020h,054h,04Fh,020h,052h,045h,053h,055h,04Dh,045h,00h
str_RemovewindowROWSPACE:                       ; "removewindow - ROW SPACE CORRUPTED\n" string literal; used
                                                ; by removewindow
        db 072h,065h,06Dh,06Fh,076h,065h,077h,069h,06Eh,064h,06Fh,077h,020h,02Dh,020h,052h
        db 04Fh,057h,020h,053h,050h,041h,043h,045h,020h,043h,04Fh,052h,052h,055h,050h,054h
        db 045h,044h,0Ah,00h
str_FshVshQfsQvs:                               ; ".fsh.vsh.qfs.qvs" string literal; used by LoadFileCached
        db 02Eh,066h,073h,068h,02Eh,076h,073h,068h,02Eh,071h,066h,073h,02Eh,071h,076h,073h
        db 00h,072h,020h,02Ah
str_Vsh:                                        ; ".vsh" string literal; used by LoadFileCached
        db 02Eh,076h,073h,068h,00h,020h,020h,063h
str_Qvs:                                        ; ".qvs" string literal; used by LoadFileCached
        db 02Eh,071h,076h,073h,00h,00h,00h,00h
str_EACSNDFLIBJul28:                            ; "EACSNDF.LIB Jul 28 1994 11:01:25" string literal
        db 045h,041h,043h,053h,04Eh,044h,046h,02Eh,04Ch,049h,042h,020h,04Ah,075h,06Ch,020h
        db 032h,038h,020h,031h,039h,039h,034h,020h,031h,031h,03Ah,030h,031h,03Ah,032h,035h
        db 00h,00h,00h,00h
str_MCGAWINDOW:                                 ; "MCGA WINDOW" string literal; used by CreateMcgaWindow
        db 04Dh,043h,047h,041h,020h,057h,049h,04Eh,044h,04Fh,057h,00h
str_WindowdefOUTOFMEMORY:                       ; "windowdef - OUT OF MEMORY\n" string literal; used by
                                                ; CreateMcgaWindow
        db 077h,069h,06Eh,064h,06Fh,077h,064h,065h,066h,020h,02Dh,020h,04Fh,055h,054h,020h
        db 04Fh,046h,020h,04Dh,045h,04Dh,04Fh,052h,059h,0Ah,00h,05Fh
str_WindowdefBADBLOCK:                          ; "windowdef - BAD BLOCK\n" string literal; used by
                                                ; CreateMcgaWindow
        db 077h,069h,06Eh,064h,06Fh,077h,064h,065h,066h,020h,02Dh,020h,042h,041h,044h,020h
        db 042h,04Ch,04Fh,043h,04Bh,0Ah,00h,067h
str_WindowdefadrOUTOFROW:                       ; "windowdefadr - OUT OF ROW SPACE\nrequested: %dx%d\n" string
                                                ; literal; used by CreateMcgaWindow
        db 077h,069h,06Eh,064h,06Fh,077h,064h,065h,066h,061h,064h,072h,020h,02Dh,020h,04Fh
        db 055h,054h,020h,04Fh,046h,020h,052h,04Fh,057h,020h,053h,050h,041h,043h,045h,0Ah
        db 072h,065h,071h,075h,065h,073h,074h,065h,064h,03Ah,020h,025h,064h,078h,025h,064h
        db 0Ah,00h,00h,00h
str_Unpackf:                                    ; "unpackf" string literal; used by DrawArtAnyFormat
        db 075h,06Eh,070h,061h,063h,06Bh,066h,00h
str_Unpacking:                                  ; "unpacking...\n" string literal; used by DrawArtAnyFormat
        db 075h,06Eh,070h,061h,063h,06Bh,069h,06Eh,067h,02Eh,02Eh,02Eh,0Ah,00h,00h,00h
str_Fsh:                                        ; ".fsh" string literal
        db 02Eh,066h,073h,068h,00h,020h,076h,06Fh
str_3sh:                                        ; ".3sh" string literal
        db 02Eh,033h,073h,068h,00h,066h,061h,072h
str_SHPI:                                       ; "SHPI" string literal
        db 053h,048h,050h,049h,00h,031h,02Ch,020h
str_SHPM:                                       ; "SHPM" string literal
        db 053h,048h,050h,04Dh,00h,020h,076h,06Fh
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
str_UnknownError:                               ; "unknown error" string literal; used by strerror_
        db 075h,06Eh,06Bh,06Eh,06Fh,077h,06Eh,020h,065h,072h,072h,06Fh,072h,00h,00h,00h
        db 00h
str_BLASTER:                                    ; "BLASTER" string literal; used by ParseBlasterEnv
        db 042h,04Ch,041h,053h,054h,045h,052h,00h
str_PAT:                                        ; ".PAT" string literal; used by GusLoadMidiPatch
        db 02Eh,050h,041h,054h,00h
str_ULTRADIR:                                   ; "ULTRADIR" string literal; used by GusStartup
        db 055h,04Ch,054h,052h,041h,044h,049h,052h,00h
str_MIDI:                                       ; "\MIDI\" string literal; used by GusStartup
        db 05Ch,04Dh,049h,044h,049h,05Ch,00h,00h,00h,00h
