; Memory manager messages: low memory, high memory, and a block that could not be released.
bits 32
%include "hockey.inc"
section s_C3B98 progbits alloc noexec write align=1
global str_LOWMEM, str_HIGHMEM, str_GAP, str_ReleaseMemoryNotFound, str_ReservememINVALIDSIZE, str_ReservememOUTOFMEMORY, str_ReservememOUTOFMEMORY2, str_ReservememINVALIDTYPEFLAGS
global str_ResizememINVALIDSIZE, str_ResizememblockNOROOMTO, str_FindmemblockBLOCKNOTFOUND, str_GetmemblockNOMEMORYBLOCKS, str_InitmemmanINSUFFICIENTROW, str_EavesaCom, str_CUtilEavesaCom, str_InitgraphicsEAVESACOM
global str_CEavesaDat, str_InitgraphicsNEWVERSIONOF, str_VESA, str_InitgraphicsINITMEMMAN, str_InitgraphicsINVALIDSCREEN, str_VESAVideoBiosDriver, str_AddtimerLISTFULL, str_SUBWINDOW
global str_SubwindowdefadrOUTOFROW, str_SCN, str_03sFF03dPAT, str_03sFF03dTIM, str_KMS2, str_CFG2, str_VHDR, str_SavefileblockaOPENFAILEDFOR
global str_DBUGTXT, str_FILES, str_DATES, str_TIMES, str_CLOSED, str_TIMES2, asc_C4080, str_2d02d02d
global str_CS44xDS, str_CS44xDS2, str_Used66xFree, str_Used7uFree7u, str_NAMESIZEADREND, str_IDXNAMESIZEADR, str_80s, asc_C4200
global str_S_MemViewerDrawList, str_SPACE9x8s8s, str_SPACE9d8s8s, str_SPACE66x6, str_SPACE7d66s, asc_C428C, str_1212s9d8s8s, str_33d1212s66x66s66s44x
global asc_C42E4, str_MEMMANAGER, str_044X00000000, str_SYSTEM, str_SPACE3, str_HIGHMemoryBlock, str_LOWMemoryBlock, str_ConventionalMemory
global str_RelocatableBlock, str_NonRelocatableBlock, str_ALIGNFlagIsSet, str_PRIORITY1d, str_SequenceD, str_BlockIsPURGABLE, str_04x2, str_02x
global asc_C441C, str_FILES2, str_DATES2, str_TIMES3, str_HexmemdspOS, str_XxMMAPTXT, str_ErrorDumpingMemoryMap, str_ShapeFileIsInvalid
global str_NumDPackedD, str_ThereAreNoShapes, str_44s05x, str_Bad, str_CxCy3d3d, str_NotDrawn, str_Bytes3dRows3d, str_Spacked
global str_Packed, str_Unpacked, str_3d3d3d3dS, str_ShapeIsInvalidDraw, str_MEMSHPTXT, str_ErrorDumpingShapesList, str_ShapeFileName0, str_ShapeFileSizeLd
global str_NumberOfShapesD, str_44s66ld, str_Bytes3dRows3d2, str_XY3d3d, str_033d022X, str_R022d, str_G022d, str_B022d
global asc_C46F8, str_SCREEN2, asc_C470C, str_2d02d02d2, str_FrameRate3dFrames, str_Width3dHeight3d, str_Colours3d1stColour, str_Mvipal
global str_DATABUFFER, str_Copyright, str_UnpackINVALIDPACKCODE, str_EXITTODOSY, str_PAUSEPRESSANYKEY, str_RemovewindowROWSPACE, str_FshVshQfsQvs, str_Vsh
global str_Qvs, str_MCGAWINDOW, str_WindowdefOUTOFMEMORY, str_WindowdefBADBLOCK, str_WindowdefadrOUTOFROW, str_Unpackf, str_Unpacking, str_SHAPE2
global str_Snap, str_Pal31, str_Snap2, str_UnknownError, str_BLASTER, str_PAT, str_ULTRADIR, str_MIDI
global unk_C3FD5, str_Jan, str_Feb2, str_Mar, str_Apr, str_May2, str_Jun, str_Jul
global str_Aug, str_Sep, str_Oct, str_Nov, str_Dec, str_Wt2, unk_C40A0, str_Fs
global str_Jan2, str_Feb3, str_Mar2, str_Apr2, str_May3, str_Jun2, str_Jul2, str_Aug2
global str_Sep2, str_Oct2, str_Nov2, str_Dec2, unk_C41F0, MemViewStrings, str_X_DebugSprintf, unk_C433C
global unk_C4414, unk_C4418, unk_C4448, str_FF, str_W_DumpMemoryMap, str_Un, unk_C46C0, unk_C472C
global str_EACSNDFLIBJul28, str_Fsh, str_3sh, str_SHPI, str_SHPM, str_Error0, str_NoSuchFileOr, str_ArgumentListTooBig
global str_ExecFormatError, str_BadFileNumber, str_NotEnoughMemory, str_PermissionDenied, str_FileExists, str_CrossDeviceLink, str_InvalidArgument, str_FileTableOverflow
global str_TooManyOpenFiles, str_NoSpaceLeftOn, str_ArgumentTooLarge, str_ResultTooLarge, str_ResourceDeadlockWouldOccur
str_LOWMEM:
        db 04Ch,04Fh,057h,020h,04Dh,045h,04Dh,00h
str_HIGHMEM:
        db 048h,049h,047h,048h,020h,04Dh,045h,04Dh,00h,020h,020h,020h
str_GAP:
        db 047h,041h,050h,00h
str_ReleaseMemoryNotFound:
        db 052h,065h,06Ch,065h,061h,073h,065h,020h,04Dh,065h,06Dh,06Fh,072h,079h,020h,04Eh
        db 06Fh,074h,020h,046h,06Fh,075h,06Eh,064h,0Ah,00h,065h,02Ch
str_ReservememINVALIDSIZE:
        db 072h,065h,073h,065h,072h,076h,065h,06Dh,065h,06Dh,020h,02Dh,020h,049h,04Eh,056h
        db 041h,04Ch,049h,044h,020h,053h,049h,05Ah,045h,020h,052h,045h,051h,055h,045h,053h
        db 054h,045h,044h,0Ah,072h,065h,071h,075h,065h,073h,074h,065h,064h,03Ah,020h,025h
        db 06Ch,064h,020h,061h,076h,061h,069h,06Ch,061h,062h,06Ch,065h,03Ah,020h,025h,06Ch
        db 064h,0Ah,00h,072h
str_ReservememOUTOFMEMORY:
        db 072h,065h,073h,065h,072h,076h,065h,06Dh,065h,06Dh,020h,02Dh,020h,04Fh,055h,054h
        db 020h,04Fh,046h,020h,04Dh,045h,04Dh,04Fh,052h,059h,0Ah,072h,065h,071h,075h,065h
        db 073h,074h,065h,064h,03Ah,020h,025h,06Ch,064h,020h,061h,076h,061h,069h,06Ch,061h
        db 062h,06Ch,065h,03Ah,020h,025h,06Ch,064h,0Ah,00h,00h,00h
str_ReservememOUTOFMEMORY2:
        db 072h,065h,073h,065h,072h,076h,065h,06Dh,065h,06Dh,020h,02Dh,020h,04Fh,055h,054h
        db 020h,04Fh,046h,020h,04Dh,045h,04Dh,04Fh,052h,059h,0Ah,072h,065h,071h,075h,065h
        db 073h,074h,065h,064h,03Ah,020h,025h,06Ch,064h,020h,061h,076h,061h,069h,06Ch,061h
        db 062h,06Ch,065h,03Ah,020h,025h,06Ch,064h,0Ah,00h,065h,06Dh
str_ReservememINVALIDTYPEFLAGS:
        db 072h,065h,073h,065h,072h,076h,065h,06Dh,065h,06Dh,020h,02Dh,020h,049h,04Eh,056h
        db 041h,04Ch,049h,044h,020h,054h,059h,050h,045h,020h,046h,04Ch,041h,047h,053h,020h
        db 028h,025h,030h,034h,078h,029h,0Ah,00h
str_ResizememINVALIDSIZE:
        db 072h,065h,073h,069h,07Ah,065h,06Dh,065h,06Dh,020h,02Dh,020h,049h,04Eh,056h,041h
        db 04Ch,049h,044h,020h,053h,049h,05Ah,045h,020h,052h,045h,051h,055h,045h,053h,054h
        db 045h,044h,0Ah,072h,065h,071h,075h,065h,073h,074h,065h,064h,03Ah,020h,025h,06Ch
        db 064h,020h,061h,076h,061h,069h,06Ch,061h,062h,06Ch,065h,03Ah,020h,025h,06Ch,064h
        db 0Ah,00h,06Ch,061h
str_ResizememblockNOROOMTO:
        db 072h,065h,073h,069h,07Ah,065h,06Dh,065h,06Dh,062h,06Ch,06Fh,063h,06Bh,020h,02Dh
        db 020h,04Eh,04Fh,020h,052h,04Fh,04Fh,04Dh,020h,054h,04Fh,020h,052h,045h,053h,049h
        db 05Ah,045h,0Ah,072h,065h,071h,075h,065h,073h,074h,065h,064h,03Ah,020h,025h,06Ch
        db 064h,020h,061h,076h,061h,069h,06Ch,061h,062h,06Ch,065h,03Ah,020h,025h,06Ch,064h
        db 0Ah,00h,061h,062h
str_FindmemblockBLOCKNOTFOUND:
        db 066h,069h,06Eh,064h,06Dh,065h,06Dh,062h,06Ch,06Fh,063h,06Bh,020h,02Dh,020h,042h
        db 04Ch,04Fh,043h,04Bh,020h,04Eh,04Fh,054h,020h,046h,04Fh,055h,04Eh,044h,020h,028h
        db 025h,070h,029h,0Ah,00h,046h,04Ch,041h
str_GetmemblockNOMEMORYBLOCKS:
        db 067h,065h,074h,06Dh,065h,06Dh,062h,06Ch,06Fh,063h,06Bh,020h,02Dh,020h,04Eh,04Fh
        db 020h,04Dh,045h,04Dh,04Fh,052h,059h,020h,042h,04Ch,04Fh,043h,04Bh,053h,020h,04Ch
        db 045h,046h,054h,0Ah,00h,00h,00h,00h
str_InitmemmanINSUFFICIENTROW:
        db 069h,06Eh,069h,074h,06Dh,065h,06Dh,06Dh,061h,06Eh,020h,02Dh,020h,049h,04Eh,053h
        db 055h,046h,046h,049h,043h,049h,045h,04Eh,054h,020h,052h,04Fh,057h,020h,054h,041h
        db 042h,04Ch,045h,020h,053h,050h,041h,043h,045h,0Ah,00h,00h
str_EavesaCom:
        db 065h,061h,076h,065h,073h,061h,02Eh,063h,06Fh,06Dh,00h,04Dh
str_CUtilEavesaCom:
        db 063h,03Ah,05Ch,075h,074h,069h,06Ch,05Ch,065h,061h,076h,065h,073h,061h,02Eh,063h
        db 06Fh,06Dh,00h,06Ch
str_InitgraphicsEAVESACOM:
        db 069h,06Eh,069h,074h,067h,072h,061h,070h,068h,069h,063h,073h,020h,02Dh,020h,045h
        db 041h,056h,045h,053h,041h,02Eh,043h,04Fh,04Dh,020h,052h,045h,051h,055h,049h,052h
        db 045h,044h,020h,049h,04Eh,020h,050h,041h,054h,048h,02Eh,0Ah,050h,06Ch,065h,061h
        db 073h,065h,020h,063h,06Fh,070h,079h,020h,045h,041h,056h,045h,053h,041h,02Eh,043h
        db 04Fh,04Dh,020h,074h,06Fh,020h,079h,06Fh,075h,072h,020h,073h,079h,073h,074h,065h
        db 06Dh,02Eh,0Ah,00h
str_CEavesaDat:
        db 063h,03Ah,05Ch,065h,061h,076h,065h,073h,061h,02Eh,064h,061h,074h,00h,074h,020h
str_InitgraphicsNEWVERSIONOF:
        db 069h,06Eh,069h,074h,067h,072h,061h,070h,068h,069h,063h,073h,020h,02Dh,020h,04Eh
        db 045h,057h,020h,056h,045h,052h,053h,049h,04Fh,04Eh,020h,04Fh,046h,020h,045h,041h
        db 056h,045h,053h,041h,02Eh,043h,04Fh,04Dh,020h,052h,045h,051h,055h,049h,052h,045h
        db 044h,02Eh,0Ah,050h,06Ch,065h,061h,073h,065h,020h,069h,06Eh,073h,074h,061h,06Ch
        db 06Ch,020h,045h,041h,056h,045h,053h,041h,02Eh,043h,04Fh,04Dh,020h,061h,06Eh,064h
        db 020h,072h,065h,072h,075h,06Eh,02Eh,0Ah,00h,069h,074h,067h
str_VESA:
        db 056h,045h,053h,041h,00h,063h,073h,020h
str_InitgraphicsINITMEMMAN:
        db 069h,06Eh,069h,074h,067h,072h,061h,070h,068h,069h,063h,073h,020h,02Dh,020h,049h
        db 04Eh,049h,054h,04Dh,045h,04Dh,04Dh,041h,04Eh,020h,052h,045h,051h,055h,049h,052h
        db 045h,044h,020h,042h,045h,046h,04Fh,052h,045h,020h,049h,04Eh,049h,054h,047h,052h
        db 041h,050h,048h,049h,043h,053h,0Ah,00h
str_InitgraphicsINVALIDSCREEN:
        db 069h,06Eh,069h,074h,067h,072h,061h,070h,068h,069h,063h,073h,020h,02Dh,020h,049h
        db 04Eh,056h,041h,04Ch,049h,044h,020h,053h,043h,052h,045h,045h,04Eh,020h,053h,049h
        db 05Ah,045h,020h,028h,025h,064h,02Ch,025h,064h,029h,0Ah,00h
str_VESAVideoBiosDriver:
        db 056h,045h,053h,041h,020h,076h,069h,064h,065h,06Fh,020h,062h,069h,06Fh,073h,020h
        db 064h,072h,069h,076h,065h,072h,020h,072h,065h,071h,075h,069h,072h,065h,064h,02Eh
        db 0Ah,050h,06Ch,065h,061h,073h,065h,020h,069h,06Eh,073h,074h,061h,06Ch,06Ch,020h
        db 061h,020h,064h,072h,069h,076h,065h,072h,020h,066h,06Fh,072h,020h,079h,06Fh,075h
        db 072h,020h,076h,069h,064h,065h,06Fh,020h,063h,061h,072h,064h,020h,061h,06Eh,064h
        db 020h,072h,065h,072h,075h,06Eh,02Eh,0Ah,00h,00h,00h,00h
str_AddtimerLISTFULL:
        db 061h,064h,064h,074h,069h,06Dh,065h,072h,020h,02Dh,020h,04Ch,049h,053h,054h,020h
        db 046h,055h,04Ch,04Ch,0Ah,00h,00h,00h
str_SUBWINDOW:
        db 053h,055h,042h,057h,049h,04Eh,044h,04Fh,057h,00h,064h,020h
str_SubwindowdefadrOUTOFROW:
        db 073h,075h,062h,077h,069h,06Eh,064h,06Fh,077h,064h,065h,066h,061h,064h,072h,020h
        db 02Dh,020h,04Fh,055h,054h,020h,04Fh,046h,020h,052h,04Fh,057h,020h,053h,050h,041h
        db 043h,045h,0Ah,00h
str_SCN:
        db 053h,043h,04Eh,00h
str_03sFF03dPAT:
        db 025h,030h,02Eh,033h,073h,046h,046h,025h,030h,033h,064h,02Eh,050h,041h,054h,00h
str_03sFF03dTIM:
        db 025h,030h,02Eh,033h,073h,046h,046h,025h,030h,033h,064h,02Eh,054h,049h,04Dh,00h
str_KMS2:
        db 04Bh,04Dh,053h,00h
str_CFG2:
        db 043h,046h,047h,00h
str_VHDR:
        db 056h,048h,044h,052h,00h
unk_C3FD5:
        db 00h,00h,00h
str_SavefileblockaOPENFAILEDFOR:
        db 073h,061h,076h,065h,066h,069h,06Ch,065h,062h,06Ch,06Fh,063h,06Bh,061h,020h,02Dh
        db 020h,04Fh,050h,045h,04Eh,020h,046h,041h,049h,04Ch,045h,044h,020h,046h,04Fh,052h
        db 020h,046h,049h,04Ch,045h,020h,03Ch,025h,073h,03Eh,0Ah,00h
str_Jan:
        db 04Ah,061h,06Eh,00h
str_Feb2:
        db 046h,065h,062h,00h
str_Mar:
        db 04Dh,061h,072h,00h
str_Apr:
        db 041h,070h,072h,00h
str_May2:
        db 04Dh,061h,079h,00h
str_Jun:
        db 04Ah,075h,06Eh,00h
str_Jul:
        db 04Ah,075h,06Ch,00h
str_Aug:
        db 041h,075h,067h,00h
str_Sep:
        db 053h,065h,070h,00h
str_Oct:
        db 04Fh,063h,074h,00h
str_Nov:
        db 04Eh,06Fh,076h,00h
str_Dec:
        db 044h,065h,063h,00h
str_DBUGTXT:
        db 044h,042h,055h,047h,03Fh,03Fh,02Eh,054h,058h,054h,00h,064h
str_Wt2:
        db 077h,074h,00h,0Dh
str_FILES:
        db 046h,049h,04Ch,045h,03Ah,020h,025h,073h,0Ah,00h,020h,020h
str_DATES:
        db 044h,041h,054h,045h,03Ah,020h,025h,073h,0Ah,00h,020h,06Dh
str_TIMES:
        db 054h,049h,04Dh,045h,03Ah,020h,025h,073h,0Ah,0Ah,00h,056h
str_CLOSED:
        db 0Ah,043h,04Ch,04Fh,053h,045h,044h,0Ah,00h,069h,02Ch,020h
str_TIMES2:
        db 054h,049h,04Dh,045h,03Ah,020h,025h,073h,0Ah,00h,02Ch,020h
asc_C4080:
        db 025h,030h,032h,064h,02Dh,025h,033h,073h,02Dh,025h,030h,032h,064h,00h,020h,066h
str_2d02d02d:
        db 025h,032h,064h,03Ah,025h,030h,032h,064h,03Ah,025h,030h,032h,064h,00h,00h,00h
unk_C40A0:
        db 02Ah,02Ah,02Ah,02Ah,02Ah,02Ah,02Ah,02Ah,02Ah,02Ah,02Ah,02Ah,02Ah,02Ah,02Ah,02Ah
        db 02Ah,02Ah,02Ah,02Ah,02Ah,02Ah,02Ah,02Ah,02Ah,02Ah,02Ah,02Ah,02Ah,02Ah,02Ah,02Ah
        db 02Ah,02Ah,02Ah,02Ah,02Ah,02Ah,02Ah,02Ah,00h,020h,02Ah,066h
str_Fs:
        db 025h,046h,073h,00h
str_Jan2:
        db 04Ah,061h,06Eh,00h
str_Feb3:
        db 046h,065h,062h,00h
str_Mar2:
        db 04Dh,061h,072h,00h
str_Apr2:
        db 041h,070h,072h,00h
str_May3:
        db 04Dh,061h,079h,00h
str_Jun2:
        db 04Ah,075h,06Eh,00h
str_Jul2:
        db 04Ah,075h,06Ch,00h
str_Aug2:
        db 041h,075h,067h,00h
str_Sep2:
        db 053h,065h,070h,00h
str_Oct2:
        db 04Fh,063h,074h,00h
str_Nov2:
        db 04Eh,06Fh,076h,00h
str_Dec2:
        db 044h,065h,063h,00h
str_CS44xDS:
        db 043h,053h,03Dh,025h,034h,02Eh,034h,078h,020h,044h,053h,03Dh,025h,034h,02Eh,034h
        db 078h,020h,020h,048h,057h,03Dh,025h,036h,02Eh,036h,078h,020h,020h,050h,06Fh,06Fh
        db 06Ch,03Dh,025h,036h,02Eh,036h,078h,020h,00h,072h,020h,066h
str_CS44xDS2:
        db 043h,053h,03Dh,025h,034h,02Eh,034h,078h,020h,044h,053h,03Dh,025h,034h,02Eh,034h
        db 078h,020h,020h,048h,057h,03Dh,025h,02Dh,037h,075h,020h,050h,06Fh,06Fh,06Ch,03Dh
        db 025h,02Dh,037h,075h,00h,00h,00h,00h
str_Used66xFree:
        db 055h,073h,065h,064h,03Dh,025h,036h,02Eh,036h,078h,020h,020h,046h,072h,065h,065h
        db 03Dh,025h,036h,02Eh,036h,078h,020h,020h,04Ch,061h,072h,067h,073h,074h,03Dh,025h
        db 036h,02Eh,036h,078h,020h,00h,02Ah,02Ah
str_Used7uFree7u:
        db 055h,073h,065h,064h,03Dh,025h,02Dh,037h,075h,020h,046h,072h,065h,065h,03Dh,025h
        db 02Dh,037h,075h,020h,04Ch,061h,072h,067h,073h,074h,03Dh,025h,02Dh,037h,075h,00h
str_NAMESIZEADREND:
        db 020h,020h,020h,020h,04Eh,041h,04Dh,045h,020h,020h,020h,020h,020h,020h,053h,049h
        db 05Ah,045h,020h,020h,020h,020h,020h,020h,020h,041h,044h,052h,020h,020h,020h,020h
        db 020h,020h,045h,04Eh,044h,020h,020h,00h
str_IDXNAMESIZEADR:
        db 049h,044h,058h,020h,020h,020h,020h,020h,04Eh,041h,04Dh,045h,020h,020h,020h,020h
        db 020h,020h,020h,053h,049h,05Ah,045h,020h,020h,020h,020h,041h,044h,052h,020h,020h
        db 020h,020h,045h,04Eh,044h,020h,020h,046h,04Ch,041h,047h,00h
unk_C41F0:
        db 025h,063h,00h,048h
str_80s:
        db 025h,02Dh,038h,030h,073h,00h,020h,050h
MemViewStrings:
        db 00h,00h,00h,00h
asc_C4200:
        db 025h,073h,0Ah,00h
str_S_MemViewerDrawList:
        db 025h,073h,0Ah,0Ah,00h,078h,020h,020h
str_SPACE9x8s8s:
        db 020h,020h,020h,020h,020h,053h,050h,041h,043h,045h,020h,020h,020h,025h,039h,078h
        db 020h,025h,038h,073h,020h,025h,038h,073h,00h,00h,02Ah,02Ah
str_SPACE9d8s8s:
        db 020h,020h,020h,020h,020h,053h,050h,041h,043h,045h,020h,020h,020h,025h,039h,064h
        db 020h,025h,038h,073h,020h,025h,038h,073h,00h,074h,03Dh,025h
str_SPACE66x6:
        db 020h,020h,020h,020h,020h,020h,020h,053h,050h,041h,043h,045h,020h,020h,020h,020h
        db 020h,020h,025h,036h,02Eh,036h,078h,020h,025h,036h,02Eh,036h,073h,020h,025h,036h
        db 02Eh,036h,073h,00h
str_SPACE7d66s:
        db 020h,020h,020h,020h,020h,020h,020h,053h,050h,041h,043h,045h,020h,020h,020h,020h
        db 020h,025h,037h,064h,020h,025h,036h,02Eh,036h,073h,020h,025h,036h,02Eh,036h,073h
        db 00h,020h,020h,041h
asc_C428C:
        db 025h,02Dh,031h,032h,02Eh,031h,032h,073h,020h,025h,039h,078h,020h,025h,038h,073h
        db 020h,025h,038h,073h,00h,02Dh,038h,030h
str_1212s9d8s8s:
        db 025h,02Dh,031h,032h,02Eh,031h,032h,073h,020h,025h,039h,064h,020h,025h,038h,073h
        db 020h,025h,038h,073h,00h,00h,00h,00h
str_33d1212s66x66s66s44x:
        db 025h,033h,02Eh,033h,064h,020h,025h,02Dh,031h,032h,02Eh,031h,032h,073h,020h,020h
        db 025h,036h,02Eh,036h,078h,020h,025h,036h,02Eh,036h,073h,020h,025h,036h,02Eh,036h
        db 073h,020h,025h,034h,02Eh,034h,078h,00h
asc_C42E4:
        db 025h,033h,02Eh,033h,064h,020h,025h,02Dh,031h,032h,02Eh,031h,032h,073h,020h,025h
        db 037h,064h,020h,025h,036h,02Eh,036h,073h,020h,025h,036h,02Eh,036h,073h,020h,025h
        db 034h,02Eh,034h,078h,00h,041h,043h,045h
str_MEMMANAGER:
        db 04Dh,045h,04Dh,020h,04Dh,041h,04Eh,041h,047h,045h,052h,00h
str_X_DebugSprintf:
        db 025h,078h,00h,036h
str_044X00000000:
        db 025h,030h,034h,02Eh,034h,058h,020h,028h,030h,030h,030h,030h,020h,030h,030h,030h
        db 030h,020h,030h,030h,030h,030h,020h,030h,030h,030h,030h,029h,00h,025h,036h,02Eh
unk_C433C:
        db 031h,00h,020h,025h
str_SYSTEM:
        db 020h,053h,059h,053h,054h,045h,04Dh,020h,00h,02Dh,031h,032h
str_SPACE3:
        db 020h,053h,050h,041h,043h,045h,020h,00h
str_HIGHMemoryBlock:
        db 048h,049h,047h,048h,020h,06Dh,065h,06Dh,06Fh,072h,079h,020h,062h,06Ch,06Fh,063h
        db 06Bh,00h,00h,00h
str_LOWMemoryBlock:
        db 04Ch,04Fh,057h,020h,06Dh,065h,06Dh,06Fh,072h,079h,020h,062h,06Ch,06Fh,063h,06Bh
        db 00h,036h,02Eh,036h
str_ConventionalMemory:
        db 043h,06Fh,06Eh,076h,065h,06Eh,074h,069h,06Fh,06Eh,061h,06Ch,020h,06Dh,065h,06Dh
        db 06Fh,072h,079h,00h
str_RelocatableBlock:
        db 052h,065h,06Ch,06Fh,063h,061h,074h,061h,062h,06Ch,065h,020h,062h,06Ch,06Fh,063h
        db 06Bh,00h,020h,025h
str_NonRelocatableBlock:
        db 04Eh,06Fh,06Eh,02Dh,052h,065h,06Ch,06Fh,063h,061h,074h,061h,062h,06Ch,065h,020h
        db 062h,06Ch,06Fh,063h,06Bh,00h,04Dh,020h
str_ALIGNFlagIsSet:
        db 041h,04Ch,049h,047h,04Eh,020h,066h,06Ch,061h,067h,020h,069h,073h,020h,073h,065h
        db 074h,00h,020h,028h
str_PRIORITY1d:
        db 050h,052h,049h,04Fh,052h,049h,054h,059h,020h,023h,025h,031h,064h,00h,020h,030h
str_SequenceD:
        db 053h,065h,071h,075h,065h,06Eh,063h,065h,020h,023h,025h,064h,00h,053h,059h,053h
str_BlockIsPURGABLE:
        db 042h,06Ch,06Fh,063h,06Bh,020h,069h,073h,020h,050h,055h,052h,047h,041h,042h,04Ch
        db 045h,00h,047h,048h
str_04x2:
        db 025h,030h,034h,078h,020h,020h,020h,00h
str_02x:
        db 025h,030h,032h,078h,00h,00h,00h,00h
unk_C4414:
        db 02Ah,00h,057h,020h
unk_C4418:
        db 020h,00h,06Dh,06Fh
asc_C441C:
        db 020h,020h,020h,020h,00h,06Fh,063h,06Bh
str_FILES2:
        db 02Ah,020h,046h,049h,04Ch,045h,03Ah,020h,025h,073h,0Ah,00h
str_DATES2:
        db 02Ah,020h,044h,041h,054h,045h,03Ah,020h,025h,073h,0Ah,00h
str_TIMES3:
        db 02Ah,020h,054h,049h,04Dh,045h,03Ah,020h,025h,073h,0Ah,00h
unk_C4448:
        db 04Eh,00h,06Fh,063h
str_FF:
        db 046h,046h,00h,025h
str_HexmemdspOS:
        db 068h,065h,078h,06Dh,065h,06Dh,064h,073h,070h,020h,03Dh,020h,04Fh,025h,073h,0Ah
        db 0Ah,00h,06Fh,063h
str_XxMMAPTXT:
        db 078h,078h,04Dh,04Dh,041h,050h,03Fh,03Fh,02Eh,054h,058h,054h,00h,067h,020h,069h
str_W_DumpMemoryMap:
        db 077h,00h,073h,065h
str_ErrorDumpingMemoryMap:
        db 045h,072h,072h,06Fh,072h,020h,044h,075h,06Dh,070h,069h,06Eh,067h,020h,04Dh,065h
        db 06Dh,06Fh,072h,079h,020h,04Dh,061h,070h,00h,06Eh,063h,065h
str_ShapeFileIsInvalid:
        db 053h,068h,061h,070h,065h,020h,066h,069h,06Ch,065h,020h,069h,073h,020h,069h,06Eh
        db 076h,061h,06Ch,069h,064h,02Eh,020h,020h,057h,06Fh,072h,06Bh,020h,077h,069h,074h
        db 068h,020h,069h,074h,03Fh,00h,032h,078h
str_NumDPackedD:
        db 04Eh,075h,06Dh,020h,03Dh,020h,025h,064h,02Ch,020h,023h,020h,070h,061h,063h,06Bh
        db 065h,064h,020h,03Dh,020h,025h,064h,02Ch,020h,023h,020h,06Eh,06Fh,074h,020h,070h
        db 061h,063h,06Bh,065h,064h,020h,03Dh,020h,025h,064h,02Ch,020h,023h,020h,06Eh,06Fh
        db 020h,073h,068h,06Fh,077h,073h,020h,03Dh,020h,025h,064h,0Ah,00h,054h,049h,04Dh
str_ThereAreNoShapes:
        db 054h,068h,065h,072h,065h,020h,061h,072h,065h,020h,06Eh,06Fh,020h,073h,068h,061h
        db 070h,065h,073h,020h,074h,068h,061h,074h,020h,063h,061h,06Eh,020h,062h,065h,020h
        db 073h,068h,06Fh,077h,06Eh,021h,00h,041h
str_44s05x:
        db 027h,025h,034h,02Eh,034h,073h,027h,020h,025h,030h,035h,078h,03Ah,020h,00h,045h
str_Bad:
        db 042h,061h,064h,02Eh,0Ah,00h,075h,06Dh
str_CxCy3d3d:
        db 063h,078h,02Fh,063h,079h,020h,03Dh,020h,025h,033h,064h,02Fh,025h,033h,064h,020h
        db 02Dh,020h,00h,053h
str_NotDrawn:
        db 04Eh,06Fh,074h,020h,064h,072h,061h,077h,06Eh,02Eh,0Ah,00h
str_Bytes3dRows3d:
        db 062h,079h,074h,065h,073h,020h,03Dh,020h,025h,033h,064h,02Ch,020h,072h,06Fh,077h
        db 073h,020h,03Dh,020h,025h,033h,064h,02Ch,020h,078h,02Fh,079h,020h,03Dh,020h,025h
        db 033h,064h,02Fh,025h,033h,064h,02Ch,020h,063h,078h,02Fh,063h,079h,020h,03Dh,020h
        db 025h,033h,064h,02Fh,025h,033h,064h,00h
str_Un:
        db 075h,06Eh,00h,061h
str_Spacked:
        db 020h,025h,073h,070h,061h,063h,06Bh,065h,064h,0Ah,00h,023h
str_Packed:
        db 070h,061h,063h,06Bh,065h,064h,020h,020h,00h,020h,03Dh,020h
str_Unpacked:
        db 075h,06Eh,070h,061h,063h,06Bh,065h,064h,00h,065h,072h,065h
str_3d3d3d3dS:
        db 025h,033h,064h,02Fh,025h,033h,064h,02Ch,020h,025h,033h,064h,02Fh,025h,033h,064h
        db 02Ch,020h,025h,073h,00h,061h,06Eh,020h
str_ShapeIsInvalidDraw:
        db 053h,068h,061h,070h,065h,020h,069h,073h,020h,069h,06Eh,076h,061h,06Ch,069h,064h
        db 02Eh,020h,020h,044h,072h,061h,077h,020h,069h,074h,020h,061h,06Eh,079h,077h,061h
        db 079h,073h,03Fh,00h
str_MEMSHPTXT:
        db 04Dh,045h,04Dh,053h,048h,050h,03Fh,03Fh,02Eh,054h,058h,054h,00h,064h,020h,02Dh
str_ErrorDumpingShapesList:
        db 045h,072h,072h,06Fh,072h,020h,044h,075h,06Dh,070h,069h,06Eh,067h,020h,053h,068h
        db 061h,070h,065h,073h,020h,04Ch,069h,073h,074h,00h,02Ch,020h
str_ShapeFileName0:
        db 053h,068h,061h,070h,065h,020h,066h,069h,06Ch,065h,020h,06Eh,061h,06Dh,065h,03Ah
        db 020h,025h,030h,02Eh,031h,032h,073h,0Ah,00h,00h,00h,00h
str_ShapeFileSizeLd:
        db 053h,068h,061h,070h,065h,020h,066h,069h,06Ch,065h,020h,073h,069h,07Ah,065h,03Ah
        db 020h,025h,06Ch,064h,0Ah,00h,064h,0Ah
str_NumberOfShapesD:
        db 04Eh,075h,06Dh,062h,065h,072h,020h,06Fh,066h,020h,073h,068h,061h,070h,065h,073h
        db 03Ah,020h,025h,064h,0Ah,0Ah,00h,065h
str_44s66ld:
        db 027h,025h,02Dh,034h,02Eh,034h,073h,027h,020h,040h,020h,025h,036h,02Eh,036h,06Ch
        db 064h,02Ch,020h,00h
str_Bytes3dRows3d2:
        db 062h,079h,074h,065h,073h,020h,03Dh,020h,025h,033h,064h,02Ch,020h,072h,06Fh,077h
        db 073h,020h,03Dh,020h,025h,033h,064h,02Ch,020h,00h,072h,061h
str_XY3d3d:
        db 078h,02Fh,079h,020h,03Dh,020h,025h,033h,064h,02Fh,025h,033h,064h,02Ch,020h,063h
        db 078h,02Fh,063h,079h,020h,03Dh,020h,025h,033h,064h,02Fh,025h,033h,064h,00h,072h
unk_C46C0:
        db 0Ah,00h,072h,020h
str_033d022X:
        db 025h,030h,033h,02Eh,033h,064h,020h,028h,025h,030h,032h,02Eh,032h,058h,029h,00h
str_R022d:
        db 052h,03Dh,025h,030h,032h,02Eh,032h,064h,00h,070h,065h,020h
str_G022d:
        db 047h,03Dh,025h,030h,032h,02Eh,032h,064h,00h,00h,00h,00h
str_B022d:
        db 042h,03Dh,025h,030h,032h,02Eh,032h,064h,00h,065h,020h,073h
asc_C46F8:
        db 025h,030h,032h,064h,00h,025h,06Ch,064h
str_SCREEN2:
        db 053h,043h,052h,045h,045h,04Eh,03Fh,03Fh,02Eh,02Ah,00h,06Fh
asc_C470C:
        db 025h,030h,032h,064h,02Dh,025h,033h,073h,02Dh,025h,030h,032h,064h,00h,00h,065h
str_2d02d02d2:
        db 025h,032h,064h,03Ah,025h,030h,032h,064h,03Ah,025h,030h,032h,064h,00h,00h,00h
unk_C472C:
        db 03Ah,020h,00h,00h
str_FrameRate3dFrames:
        db 046h,072h,061h,06Dh,065h,020h,052h,061h,074h,065h,03Ah,020h,025h,033h,064h,020h
        db 046h,072h,061h,06Dh,065h,073h,03Ah,020h,025h,033h,064h,020h,042h,06Ch,06Fh,063h
        db 06Bh,020h,053h,069h,07Ah,065h,03Ah,020h,025h,033h,064h,0Ah,00h,06Dh,065h,02Ch
str_Width3dHeight3d:
        db 057h,069h,064h,074h,068h,03Ah,020h,025h,033h,064h,020h,020h,020h,020h,020h,020h
        db 048h,065h,069h,067h,068h,074h,03Ah,020h,025h,033h,064h,0Ah,00h,063h,064h,065h
str_Colours3d1stColour:
        db 043h,06Fh,06Ch,06Fh,075h,072h,073h,03Ah,020h,025h,033h,064h,020h,020h,020h,020h
        db 031h,073h,074h,020h,043h,06Fh,06Ch,06Fh,075h,072h,03Ah,020h,025h,033h,064h,0Ah
        db 00h,066h,069h,072h
str_Mvipal:
        db 06Dh,076h,069h,070h,061h,06Ch,00h,020h
str_DATABUFFER:
        db 044h,041h,054h,041h,042h,055h,046h,046h,045h,052h,00h,00h
str_Copyright:
        db 043h,06Fh,070h,079h,072h,069h,067h,068h,074h,00h,020h,066h
str_UnpackINVALIDPACKCODE:
        db 075h,06Eh,070h,061h,063h,06Bh,020h,02Dh,020h,049h,04Eh,056h,041h,04Ch,049h,044h
        db 020h,050h,041h,043h,04Bh,020h,043h,04Fh,044h,045h,020h,028h,025h,078h,029h,0Ah
        db 00h,00h,00h,00h
str_EXITTODOSY:
        db 045h,058h,049h,054h,020h,054h,04Fh,020h,044h,04Fh,053h,020h,028h,059h,02Fh,04Eh
        db 029h,00h,069h,07Ah
str_PAUSEPRESSANYKEY:
        db 050h,041h,055h,053h,045h,020h,02Dh,020h,050h,052h,045h,053h,053h,020h,041h,04Eh
        db 059h,020h,04Bh,045h,059h,020h,054h,04Fh,020h,052h,045h,053h,055h,04Dh,045h,00h
str_RemovewindowROWSPACE:
        db 072h,065h,06Dh,06Fh,076h,065h,077h,069h,06Eh,064h,06Fh,077h,020h,02Dh,020h,052h
        db 04Fh,057h,020h,053h,050h,041h,043h,045h,020h,043h,04Fh,052h,052h,055h,050h,054h
        db 045h,044h,0Ah,00h
str_FshVshQfsQvs:
        db 02Eh,066h,073h,068h,02Eh,076h,073h,068h,02Eh,071h,066h,073h,02Eh,071h,076h,073h
        db 00h,072h,020h,02Ah
str_Vsh:
        db 02Eh,076h,073h,068h,00h,020h,020h,063h
str_Qvs:
        db 02Eh,071h,076h,073h,00h,00h,00h,00h
str_EACSNDFLIBJul28:
        db 045h,041h,043h,053h,04Eh,044h,046h,02Eh,04Ch,049h,042h,020h,04Ah,075h,06Ch,020h
        db 032h,038h,020h,031h,039h,039h,034h,020h,031h,031h,03Ah,030h,031h,03Ah,032h,035h
        db 00h,00h,00h,00h
str_MCGAWINDOW:
        db 04Dh,043h,047h,041h,020h,057h,049h,04Eh,044h,04Fh,057h,00h
str_WindowdefOUTOFMEMORY:
        db 077h,069h,06Eh,064h,06Fh,077h,064h,065h,066h,020h,02Dh,020h,04Fh,055h,054h,020h
        db 04Fh,046h,020h,04Dh,045h,04Dh,04Fh,052h,059h,0Ah,00h,05Fh
str_WindowdefBADBLOCK:
        db 077h,069h,06Eh,064h,06Fh,077h,064h,065h,066h,020h,02Dh,020h,042h,041h,044h,020h
        db 042h,04Ch,04Fh,043h,04Bh,0Ah,00h,067h
str_WindowdefadrOUTOFROW:
        db 077h,069h,06Eh,064h,06Fh,077h,064h,065h,066h,061h,064h,072h,020h,02Dh,020h,04Fh
        db 055h,054h,020h,04Fh,046h,020h,052h,04Fh,057h,020h,053h,050h,041h,043h,045h,0Ah
        db 072h,065h,071h,075h,065h,073h,074h,065h,064h,03Ah,020h,025h,064h,078h,025h,064h
        db 0Ah,00h,00h,00h
str_Unpackf:
        db 075h,06Eh,070h,061h,063h,06Bh,066h,00h
str_Unpacking:
        db 075h,06Eh,070h,061h,063h,06Bh,069h,06Eh,067h,02Eh,02Eh,02Eh,0Ah,00h,00h,00h
str_Fsh:
        db 02Eh,066h,073h,068h,00h,020h,076h,06Fh
str_3sh:
        db 02Eh,033h,073h,068h,00h,066h,061h,072h
str_SHPI:
        db 053h,048h,050h,049h,00h,031h,02Ch,020h
str_SHPM:
        db 053h,048h,050h,04Dh,00h,020h,076h,06Fh
str_SHAPE2:
        db 053h,048h,041h,050h,045h,00h,061h,072h
str_Snap:
        db 053h,06Eh,061h,070h,00h,032h,02Ch,020h
str_Pal31:
        db 021h,070h,061h,06Ch,00h,074h,020h,05Fh
str_Snap2:
        db 073h,06Eh,061h,070h,00h,00h,00h,00h
str_Error0:
        db 045h,072h,072h,06Fh,072h,020h,030h,00h
str_NoSuchFileOr:
        db 04Eh,06Fh,020h,073h,075h,063h,068h,020h,066h,069h,06Ch,065h,020h,06Fh,072h,020h
        db 064h,069h,072h,065h,063h,074h,06Fh,072h,079h,00h
str_ArgumentListTooBig:
        db 041h,072h,067h,075h,06Dh,065h,06Eh,074h,020h,06Ch,069h,073h,074h,020h,074h,06Fh
        db 06Fh,020h,062h,069h,067h,00h
str_ExecFormatError:
        db 045h,078h,065h,063h,020h,066h,06Fh,072h,06Dh,061h,074h,020h,065h,072h,072h,06Fh
        db 072h,00h
str_BadFileNumber:
        db 042h,061h,064h,020h,066h,069h,06Ch,065h,020h,06Eh,075h,06Dh,062h,065h,072h,00h
str_NotEnoughMemory:
        db 04Eh,06Fh,074h,020h,065h,06Eh,06Fh,075h,067h,068h,020h,06Dh,065h,06Dh,06Fh,072h
        db 079h,00h
str_PermissionDenied:
        db 050h,065h,072h,06Dh,069h,073h,073h,069h,06Fh,06Eh,020h,064h,065h,06Eh,069h,065h
        db 064h,00h
str_FileExists:
        db 046h,069h,06Ch,065h,020h,065h,078h,069h,073h,074h,073h,00h
str_CrossDeviceLink:
        db 043h,072h,06Fh,073h,073h,02Dh,064h,065h,076h,069h,063h,065h,020h,06Ch,069h,06Eh
        db 06Bh,00h
str_InvalidArgument:
        db 049h,06Eh,076h,061h,06Ch,069h,064h,020h,061h,072h,067h,075h,06Dh,065h,06Eh,074h
        db 00h
str_FileTableOverflow:
        db 046h,069h,06Ch,065h,020h,074h,061h,062h,06Ch,065h,020h,06Fh,076h,065h,072h,066h
        db 06Ch,06Fh,077h,00h
str_TooManyOpenFiles:
        db 054h,06Fh,06Fh,020h,06Dh,061h,06Eh,079h,020h,06Fh,070h,065h,06Eh,020h,066h,069h
        db 06Ch,065h,073h,00h
str_NoSpaceLeftOn:
        db 04Eh,06Fh,020h,073h,070h,061h,063h,065h,020h,06Ch,065h,066h,074h,020h,06Fh,06Eh
        db 020h,064h,065h,076h,069h,063h,065h,00h
str_ArgumentTooLarge:
        db 041h,072h,067h,075h,06Dh,065h,06Eh,074h,020h,074h,06Fh,06Fh,020h,06Ch,061h,072h
        db 067h,065h,00h
str_ResultTooLarge:
        db 052h,065h,073h,075h,06Ch,074h,020h,074h,06Fh,06Fh,020h,06Ch,061h,072h,067h,065h
        db 00h
str_ResourceDeadlockWouldOccur:
        db 052h,065h,073h,06Fh,075h,072h,063h,065h,020h,064h,065h,061h,064h,06Ch,06Fh,063h
        db 06Bh,020h,077h,06Fh,075h,06Ch,064h,020h,06Fh,063h,063h,075h,072h,00h
str_UnknownError:
        db 075h,06Eh,06Bh,06Eh,06Fh,077h,06Eh,020h,065h,072h,072h,06Fh,072h,00h,00h,00h
        db 00h
str_BLASTER:
        db 042h,04Ch,041h,053h,054h,045h,052h,00h
str_PAT:
        db 02Eh,050h,041h,054h,00h
str_ULTRADIR:
        db 055h,04Ch,054h,052h,041h,044h,049h,052h,00h
str_MIDI:
        db 05Ch,04Dh,049h,044h,049h,05Ch,00h,00h,00h,00h
