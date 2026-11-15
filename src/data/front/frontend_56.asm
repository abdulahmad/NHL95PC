; Highlight descriptions, sound-device names, and the palette fade steps.
bits 32
%include "hockey.inc"
section s_D1084 progbits alloc noexec write align=1
extern dblistcur, dblisttemp, dblistorig, str_ANA4, str_BOS2, str_BUF4, str_CGY2, str_CHI2
extern str_DAL2, str_DET2, str_EDM2, str_FLA2, str_HFD2, str_LA2, str_MTL2, str_NJ2
extern str_NYI2, str_NYR2, str_OTT2, str_PHI2, str_PIT2, str_QUE2, str_STL2, str_SJ2
extern str_TB2, str_TOR2, str_VAN2, str_WSH2, str_WPG2, str_ASW2, str_ASE2, str_WesternConferenceQuarter
extern str_EasternConferenceQuarter, str_StanleyCupFinals, str_RoughingPen, str_ChargingPen, str_SlashingPen, str_XcheckPen, str_HookingPen, str_TrippingPen
extern str_InterferPen, str_HoldingPen, str_AbusePen, str_CheckbndPen, str_BoardingPen, str_ElbowingPen, str_HistickPen, str_SpearingPen
global str_HilightDescFmt, str_Exhibition2, str_Playoff, str_League2, str_ShowLeague, str_Settings3, str_PCBEEP, str_SBDAC, fadestart, fadestep, fadestart2, fadestep2
global str_ADLIB, str_MT322, str_SBDAC2, str_PCBEEP2, str_SoundBlaster2, str_Adlib, str_MT323, str_ULTRASOUND
global str_SS5, str_PauseCor, str_AtCor, str_1minuteCor, str_MinutesCor, str_1secondCor, str_SecondsCor, str_PennumCor
global str_PensnumCor, str_PenshotCor, str_GoalnumCor, str_AsstnumCor, str_AndnumCor, str_OneleftCor, str_2minCor, str_5minCor
global str_NumberCor, str_NowbackInt, str_BackmomtInt, str_CoachclpInt, str_OfBar, str_AndBar, str_BetweenBar, str_GamenumBar
global str_EasportsBar, str_TonightBar, str_GamebtwnBar, str_GoodniteInt, str_LineupsInt, str_TakeynowBar, str_HighliteBar, str_OvertimeBar
global str_HavewonBar, str_Scor1perBar, str_Scor2perBar, str_Scor3perBar, str_Scor1otpBar, str_Scor2otpBar, str_Scor3otpBar, str_ScortotpBar
global str_ThegameBar, str_VIV, str_AGameYouRequire3, byte_D11BC, fadeend, fadeend2, jerseyremap
global byte_D12DE, jerseypalslot0, jerseypalslot1, jerseypalslot2, jerseypalslot3, musicslot, musicon, crowddriver
global byte_D27B6, dbdlgrects
global dword_D1229, dword_D122B, dword_D122F, dword_D1231, lineslotx
global linesloty, dword_D1398, dword_D139C, dword_D13C8, dword_D13CC, dword_D1418, dword_D141C, dword_D1458
global dword_D145C, dword_D1468, dword_D146C, jerseydigits, leaguesetrects
global modesetrects, exhsetrects
global ctldlgrects
global ctldlgalt, rockcuepool, teamtunepathsel, rockcuepathsel, gadgetrects, gadgetrect_y0, gadgetrect_x1, gadgetrect_y1
global settingsfile, lockerindex, lockerteams, poroundnameidx, lockerrects
global lockeracceptx, lockeraccepty
global lockercancelx, lockercancely, dword_D2350, soundcardrects, dword_D2423
global dword_D2427, digidriver, musichandle, sndtempbuf, sounddevids, sndcardname, str_Cor2
global speechchannel, speechcopylen, speechinit, dbtablists, rockcuefiles, teamrockcuetbl, teamtunefiles, msg_NoHilightSpace
global jerseyabbrevs, poroundnames, msg_InitMT32, penaltyclips, scorperclips, msg_SavingLeagueGame, msg_SavingPlayoffGame, msg_NoSaveSpace
global str_ConfirmDeletionOfThe2, deldbmsg, unk_D12C8, dlggreys, ctlboxrect1, ctlboxrect2, str_BOS1, str_BOS22
global str_BOS3, str_HART2, str_BUF22, str_CAL1, str_CAL2, str_CAL3, str_CHIC1, str_CHIC2
global str_CHIC3, str_DET1, str_DET22, str_ED1, str_HART1, str_HART22, str_HART3, str_LA1
global str_LA4, str_MON1, str_MON2, str_MON3, str_HART23, str_NJER2, str_LI2, str_LI3
global str_NY3, str_PHIL1, str_PHIL2, str_CGY22, str_PITTS1, str_PITTS2, str_PITTS3, str_PITTS4
global str_QU1, str_SL1, str_SL2, str_SL3, str_SHK1, str_SHK2, str_MON12, str_MON32
global str_LA42, str_SHK7, str_SHK8, str_BOS23, str_TB22, str_TOR1, str_TOR22, str_VAN1
global str_VAN3, str_WASH3, str_WINN2, str_ROCKDITI2, str_CANADA, str_USA, str_InsufficientDiskSpaceTo2, str_SaveHilights
global str_CurrentHilightNotSaved, str_ThereAreNoHilights, msg_NoHilights, str_ThereIsNotEnogh, str_TheFloppyDiskFor, str_SelectLessHilightsOr, str_ThereIsNotEnogh2, str_TheHardDiskFor
global str_TrySelectingLessHilights, str_TheHilight, str_AlreadyExists, str_ExportingHilights, str_PC, sndselbox1, sndselbox2, str_CouldNotFindA
global str_CardInThisMachine, msg_NoSoundCard, str_InitializingTheMT32Card, str_PleaseWait, str_1ststarCor, str_2ndstarCor, unk_D279A, str_SavingCurrent
global str_LeagueGame, str_PlayOffGame, str_InsufficientDiskSpaceTo3, str_OfFreeDiskSpace2
dbdlgrects:
db 0Eh,00h,00h,00h
db 033h,00h,00h,00h
db 01Ah,00h,00h,00h
db 03Dh,00h,00h,00h,0Eh,00h,00h,00h,094h,00h,00h,00h,01Ah,00h,00h,00h
db 09Eh,00h,00h,00h,019h,00h,00h,00h,0ACh,00h,00h,00h,04Bh,00h,00h,00h
db 0BCh,00h,00h,00h,060h,00h,00h,00h,0ACh,00h,00h,00h,092h,00h,00h,00h
db 0BCh,00h,00h,00h,0A7h,00h,00h,00h,0ACh,00h,00h,00h,0D9h,00h,00h,00h
db 0BCh,00h,00h,00h,099h,00h,00h,00h,038h,00h,00h,00h,0E4h,00h,00h,00h
db 049h,00h,00h,00h,099h,00h,00h,00h,050h,00h,00h,00h,0E4h,00h,00h,00h
db 061h,00h,00h,00h,099h,00h,00h,00h,068h,00h,00h,00h,0E4h,00h,00h,00h
db 079h,00h,00h,00h
db 0Fh,00h,00h,00h
db 041h,00h,00h,00h
db 019h,00h,00h,00h
db 090h,00h,00h,00h
db 086h,00h,00h,00h
db 09h,00h,00h,00h
db 0E9h,00h,00h,00h
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
dbtablists:
dd dblistcur
dd dblistorig
dd dblisttemp
str_ConfirmDeletionOfThe2:
db 043h,06Fh,06Eh,066h,069h,072h,06Dh,020h,064h,065h,06Ch,065h,074h,069h,06Fh,06Eh
db 020h,06Fh,066h,020h,074h,068h,065h,020h,064h,061h,074h,061h,062h,061h,073h,065h
db 03Ah,00h
deldbmsg:
dd str_ConfirmDeletionOfThe2
db 00h,00h,00h,00h,00h,00h
byte_D11BC:
db 0ADh,00h,00h,00h,0ADh,00h,00h,00h,0AAh,00h,00h,00h,0B0h,00h,00h,00h
db 0AAh,00h,00h,00h,0AAh,00h,00h,00h,0ADh,00h,00h,00h,0ADh,00h,00h,00h
db 0A2h,00h,00h,00h,0ADh,00h,00h,00h,0ADh,00h,00h,00h,0AAh,00h,00h,00h
db 0AAh,00h,00h,00h,090h,00h,00h,00h,090h,00h,00h,00h,0ADh,00h,00h,00h
db 0B0h,00h,00h,00h,0ACh,00h,00h,00h,0ADh,00h,00h,00h,0AEh,00h,00h,00h
db 0AAh,00h,00h,00h,0B0h,00h,00h,00h,0ADh,00h,00h,00h,0ADh,00h,00h,00h
db 0AAh,00h,00h,00h,0AAh,00h,00h,00h,0BCh,00h,00h,00h,09Ch
dword_D1229:
db 00h,00h
dword_D122B:
db 00h
fadestart:
db 01h
db 0Fh
fadestep:
db 01h
dword_D122F:
db 0FFh
fadeend:
db 011h
dword_D1231:
db 0FFh
fadestart2:
db 01h
db 0Fh
fadestep2:
db 01h,0FFh
fadeend2:
db 011h,0FFh
jerseyremap:
db 00h,01h,02h,03h,04h,05h,06h,07h,08h,09h,0Ah,0Bh,0Ch,0Dh,0Eh,0Fh
db 010h,011h,012h,013h,014h,015h,016h,017h,018h,019h,01Ah,01Bh,01Ch,01Dh,01Eh,01Fh
db 020h,021h,022h,023h,024h,025h,026h,027h,028h,029h,02Ah,02Bh,02Ch,02Dh,02Eh,02Fh
db 030h,031h,032h,033h,034h,035h,036h,037h,038h,039h,03Ah,03Bh,03Ch,03Dh,03Eh,03Fh
db 040h,041h,042h,043h,044h,045h,046h,047h,048h,049h,04Ah,04Bh,04Ch,04Dh,04Eh,04Fh
db 050h,051h,052h,053h,054h,055h,056h,057h,058h,059h,05Ah,05Bh,05Ch,05Dh,05Eh,05Fh
db 060h,061h,062h,063h,064h,065h,066h,067h,068h,069h,06Ah,06Bh,06Ch,06Dh,06Eh,06Fh
db 070h,071h,072h,073h,074h,075h,076h,077h,078h,079h,07Ah,07Bh,07Ch,07Dh,07Eh,07Fh
db 080h,081h,082h,083h,084h,085h,086h,087h,088h,089h,08Ah,08Bh,08Ch,08Dh,08Eh,08Fh
unk_D12C8:
db 090h,091h,092h,093h,094h,095h,096h,097h,098h,099h,09Ah,09Bh,09Ch,09Dh,09Eh,09Fh
db 0A0h,0A1h,0A2h,0A3h,0A4h,0A5h
byte_D12DE:
db 0A6h,0A7h,0A8h,0A9h,0AAh,0ABh,0ACh,0ADh,0AEh,0AFh,0B0h,0B1h,0B2h,0B3h,0B4h,0B5h
db 0B6h,0B7h,0B8h,0B9h,0BAh,0BBh,0BCh,0BDh,0BEh,0BFh,0C0h,0C1h,0C2h,0C3h,0C4h,0C5h
db 0C6h,0C7h,0C8h,0C9h,0CAh,0CBh,0CCh,0CDh,0CEh,0CFh,0D0h,0D1h,0D2h,0D3h,0D4h,0D5h
db 0D6h,0D7h,0D8h,0D9h,0DAh,0DBh,0DCh,0DDh,0DEh,0DFh,0E0h,0E1h,0E2h,0E3h,0E4h,0E5h
db 0E6h,0E7h,0E8h,0E9h,0EAh,0EBh,0ECh,0EDh,0EEh,0EFh,0F0h,0F1h,0F2h,0F3h,0F4h,0F5h
db 0F6h,0F7h,0F8h,0F9h,0FAh
jerseypalslot0:
db 0FBh
jerseypalslot1:
db 0FCh
jerseypalslot2:
db 0FDh
jerseypalslot3:
db 0FEh,0FFh
lineslotx:
db 047h,00h,00h,00h
linesloty:
db 028h,00h,00h,00h,083h,00h,00h,00h,028h,00h,00h,00h,0BFh,00h,00h,00h
db 028h,00h,00h,00h,047h,00h,00h,00h,059h,00h,00h,00h,083h,00h,00h,00h
db 059h,00h,00h,00h,0BFh,00h,00h,00h,059h,00h,00h,00h,047h,00h,00h,00h
db 08Ah,00h,00h,00h,083h,00h,00h,00h,08Ah,00h,00h,00h,0BFh,00h,00h,00h
db 08Ah,00h,00h,00h,047h,00h,00h,00h,0BBh,00h,00h,00h,083h,00h,00h,00h
db 0BBh,00h,00h,00h,0BFh,00h,00h,00h,0BBh,00h,00h,00h
dword_D1398:
db 056h,01h,00h,00h
dword_D139C:
db 028h,00h,00h,00h,092h,01h,00h,00h,028h,00h,00h,00h,056h,01h,00h,00h
db 059h,00h,00h,00h,092h,01h,00h,00h,059h,00h,00h,00h,056h,01h,00h,00h
db 08Ah,00h,00h,00h,092h,01h,00h,00h,08Ah,00h,00h,00h
dword_D13C8:
db 047h,00h,00h,00h
dword_D13CC:
db 0F6h,00h,00h,00h,083h,00h,00h,00h,0F6h,00h,00h,00h,0BFh,00h,00h,00h
db 0F6h,00h,00h,00h,0FBh,00h,00h,00h,0F6h,00h,00h,00h,037h,01h,00h,00h
db 0F6h,00h,00h,00h,047h,00h,00h,00h,027h,01h,00h,00h,083h,00h,00h,00h
db 027h,01h,00h,00h,0BFh,00h,00h,00h,027h,01h,00h,00h,0FBh,00h,00h,00h
db 027h,01h,00h,00h,037h,01h,00h,00h,027h,01h,00h,00h
dword_D1418:
db 047h,00h,00h,00h
dword_D141C:
db 062h,01h,00h,00h,083h,00h,00h,00h,062h,01h,00h,00h,0BFh,00h,00h,00h
db 062h,01h,00h,00h,0FBh,00h,00h,00h,062h,01h,00h,00h,047h,00h,00h,00h
db 093h,01h,00h,00h,083h,00h,00h,00h,093h,01h,00h,00h,0BFh,00h,00h,00h
db 093h,01h,00h,00h,0FBh,00h,00h,00h,093h,01h,00h,00h
dword_D1458:
db 099h,01h,00h,00h
dword_D145C:
db 0F5h,00h,00h,00h,099h,01h,00h,00h,022h,01h,00h,00h
dword_D1468:
db 063h,01h,00h,00h
dword_D146C:
db 093h,01h,00h,00h,09Fh,01h,00h,00h,093h,01h,00h,00h
jerseydigits:
db 0FEh,0F7h,0FFh,01h,018h,080h,01h,0F8h,0FFh,0FEh,07h,00h,00h,00h,00h,02h
db 0F8h,0FFh,0FFh,0Fh,080h,00h,00h,00h,06h,07Fh,0F8h,0C1h,019h,08Eh,071h,0F8h
db 0C3h,01Eh,0Ch,00h,06h,076h,0E0h,061h,018h,086h,061h,0F8h,0FFh,09Eh,07h,00h
db 0F0h,080h,0Fh,0CCh,060h,0Ch,0C3h,0FFh,0FFh,0C0h,00h,00h,03Fh,0F6h,0E3h,031h
db 018h,083h,031h,038h,0FFh,0C3h,07h,00h,0FEh,0F7h,0FFh,061h,018h,086h,061h,078h
db 0FEh,086h,07h,00h,07h,070h,00h,01h,01Eh,0FEh,0FDh,0F3h,03h,07h,00h,00h
db 09Eh,0F7h,0FFh,061h,018h,086h,061h,0F8h,0FFh,09Eh,07h,00h,01Eh,0F6h,0E7h,061h
db 018h,086h,061h,0F8h,0FFh,0FEh,07h,00h
leaguesetrects:
db 020h,00h,00h,00h
db 028h,00h,00h,00h
db 03Ah,00h,00h,00h
db 038h,00h,00h,00h,03Eh,00h,00h,00h,028h,00h,00h,00h,058h,00h,00h,00h
db 038h,00h,00h,00h,020h,00h,00h,00h,03Eh,00h,00h,00h,03Ah,00h,00h,00h
db 04Eh,00h,00h,00h,03Eh,00h,00h,00h,03Eh,00h,00h,00h,058h,00h,00h,00h
db 04Eh,00h,00h,00h,020h,00h,00h,00h,054h,00h,00h,00h,03Ah,00h,00h,00h
db 064h,00h,00h,00h,03Eh,00h,00h,00h,054h,00h,00h,00h,058h,00h,00h,00h
db 064h,00h,00h,00h,020h,00h,00h,00h,06Ah,00h,00h,00h,03Ah,00h,00h,00h
db 07Ah,00h,00h,00h,03Eh,00h,00h,00h,06Ah,00h,00h,00h,058h,00h,00h,00h
db 07Ah,00h,00h,00h,020h,00h,00h,00h,080h,00h,00h,00h,03Ah,00h,00h,00h
db 090h,00h,00h,00h,03Eh,00h,00h,00h,080h,00h,00h,00h,058h,00h,00h,00h
db 090h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
db 0FFh,0FFh,0FFh,0FFh,020h,00h,00h,00h,096h,00h,00h,00h,03Ah,00h,00h,00h
db 0A6h,00h,00h,00h,03Eh,00h,00h,00h,096h,00h,00h,00h,058h,00h,00h,00h
db 0A6h,00h,00h,00h,020h,00h,00h,00h,0ACh,00h,00h,00h,03Ah,00h,00h,00h
db 0BCh,00h,00h,00h,03Eh,00h,00h,00h,0ACh,00h,00h,00h,058h,00h,00h,00h
db 0BCh,00h,00h,00h,020h,00h,00h,00h,0C2h,00h,00h,00h,03Ah,00h,00h,00h
db 0D2h,00h,00h,00h,03Eh,00h,00h,00h,0C2h,00h,00h,00h,058h,00h,00h,00h
db 0D2h,00h,00h,00h,07Ch,00h,00h,00h,0EAh,00h,00h,00h,091h,00h,00h,00h
db 0FAh,00h,00h,00h,096h,00h,00h,00h,0EAh,00h,00h,00h,0ADh,00h,00h,00h
db 0FAh,00h,00h,00h,0B2h,00h,00h,00h,0EAh,00h,00h,00h,0C9h,00h,00h,00h
db 0FAh,00h,00h,00h,07Bh,00h,00h,00h,012h,01h,00h,00h,08Ch,00h,00h,00h
db 022h,01h,00h,00h,092h,00h,00h,00h,012h,01h,00h,00h,0A3h,00h,00h,00h
db 022h,01h,00h,00h,0A9h,00h,00h,00h,012h,01h,00h,00h,0BAh,00h,00h,00h
db 022h,01h,00h,00h,0C0h,00h,00h,00h,012h,01h,00h,00h,0D1h,00h,00h,00h
db 022h,01h,00h,00h,035h,00h,00h,00h,035h,01h,00h,00h,066h,00h,00h,00h
db 045h,01h,00h,00h,07Fh,00h,00h,00h,035h,01h,00h,00h,0B0h,00h,00h,00h
db 045h,01h,00h,00h
dlggreys:
db 00h,00h,00h,014h,014h,014h,02Eh,02Eh,02Eh,03Fh,03Fh,03Fh
modesetrects:
db 018h,00h,00h,00h
db 028h,00h,00h,00h
db 032h,00h,00h,00h
db 038h,00h,00h,00h,036h,00h,00h,00h,028h,00h,00h,00h,050h,00h,00h,00h
db 038h,00h,00h,00h,018h,00h,00h,00h,03Eh,00h,00h,00h,032h,00h,00h,00h
db 04Eh,00h,00h,00h,036h,00h,00h,00h,03Eh,00h,00h,00h,050h,00h,00h,00h
db 04Eh,00h,00h,00h,018h,00h,00h,00h,054h,00h,00h,00h,032h,00h,00h,00h
db 064h,00h,00h,00h,036h,00h,00h,00h,054h,00h,00h,00h,050h,00h,00h,00h
db 064h,00h,00h,00h,018h,00h,00h,00h,06Ah,00h,00h,00h,032h,00h,00h,00h
db 07Ah,00h,00h,00h,036h,00h,00h,00h,06Ah,00h,00h,00h,050h,00h,00h,00h
db 07Ah,00h,00h,00h,018h,00h,00h,00h,080h,00h,00h,00h,032h,00h,00h,00h
db 090h,00h,00h,00h,036h,00h,00h,00h,080h,00h,00h,00h,050h,00h,00h,00h
db 090h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
db 0FFh,0FFh,0FFh,0FFh,018h,00h,00h,00h,096h,00h,00h,00h,032h,00h,00h,00h
db 0A6h,00h,00h,00h,036h,00h,00h,00h,096h,00h,00h,00h,050h,00h,00h,00h
db 0A6h,00h,00h,00h,018h,00h,00h,00h,0ACh,00h,00h,00h,032h,00h,00h,00h
db 0BCh,00h,00h,00h,036h,00h,00h,00h,0ACh,00h,00h,00h,050h,00h,00h,00h
db 0BCh,00h,00h,00h,018h,00h,00h,00h,0C2h,00h,00h,00h,032h,00h,00h,00h
db 0D2h,00h,00h,00h,036h,00h,00h,00h,0C2h,00h,00h,00h,050h,00h,00h,00h
db 0D2h,00h,00h,00h,02Dh,00h,00h,00h,0E5h,00h,00h,00h,05Eh,00h,00h,00h
db 0F5h,00h,00h,00h,077h,00h,00h,00h,0E5h,00h,00h,00h,0A8h,00h,00h,00h
db 0F5h,00h,00h,00h
exhsetrects:
db 018h,00h,00h,00h
db 028h,00h,00h,00h
db 032h,00h,00h,00h
db 038h,00h,00h,00h,036h,00h,00h,00h,028h,00h,00h,00h,050h,00h,00h,00h
db 038h,00h,00h,00h,018h,00h,00h,00h,03Eh,00h,00h,00h,032h,00h,00h,00h
db 04Eh,00h,00h,00h,036h,00h,00h,00h,03Eh,00h,00h,00h,050h,00h,00h,00h
db 04Eh,00h,00h,00h,018h,00h,00h,00h,054h,00h,00h,00h,032h,00h,00h,00h
db 064h,00h,00h,00h,036h,00h,00h,00h,054h,00h,00h,00h,050h,00h,00h,00h
db 064h,00h,00h,00h,018h,00h,00h,00h,06Ah,00h,00h,00h,032h,00h,00h,00h
db 07Ah,00h,00h,00h,036h,00h,00h,00h,06Ah,00h,00h,00h,050h,00h,00h,00h
db 07Ah,00h,00h,00h,018h,00h,00h,00h,080h,00h,00h,00h,032h,00h,00h,00h
db 090h,00h,00h,00h,036h,00h,00h,00h,080h,00h,00h,00h,050h,00h,00h,00h
db 090h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
db 0FFh,0FFh,0FFh,0FFh,018h,00h,00h,00h,096h,00h,00h,00h,032h,00h,00h,00h
db 0A6h,00h,00h,00h,036h,00h,00h,00h,096h,00h,00h,00h,050h,00h,00h,00h
db 0A6h,00h,00h,00h,018h,00h,00h,00h,0ACh,00h,00h,00h,032h,00h,00h,00h
db 0BCh,00h,00h,00h,036h,00h,00h,00h,0ACh,00h,00h,00h,050h,00h,00h,00h
db 0BCh,00h,00h,00h,018h,00h,00h,00h,0C2h,00h,00h,00h,032h,00h,00h,00h
db 0D2h,00h,00h,00h,036h,00h,00h,00h,0C2h,00h,00h,00h,050h,00h,00h,00h
db 0D2h,00h,00h,00h,074h,00h,00h,00h,0EAh,00h,00h,00h,089h,00h,00h,00h
db 0FAh,00h,00h,00h,08Eh,00h,00h,00h,0EAh,00h,00h,00h,0A5h,00h,00h,00h
db 0FAh,00h,00h,00h,0AAh,00h,00h,00h,0EAh,00h,00h,00h,0C1h,00h,00h,00h
db 0FAh,00h,00h,00h,02Dh,00h,00h,00h,0Dh,01h,00h,00h,05Eh,00h,00h,00h
db 01Dh,01h,00h,00h,077h,00h,00h,00h,0Dh,01h,00h,00h,0A8h,00h,00h,00h
db 01Dh,01h,00h,00h
ctldlgrects:
db 010h,00h,00h,00h
db 021h,00h,00h,00h
db 087h,00h,00h,00h
db 032h,00h,00h,00h
db 010h,00h,00h,00h
db 037h,00h,00h,00h
db 087h,00h,00h,00h
db 048h,00h,00h,00h
db 01Bh,00h,00h,00h
db 065h,00h,00h,00h,07Ch,00h,00h,00h,076h,00h,00h,00h
db 01Bh,00h,00h,00h
db 07Ah,00h,00h,00h,07Ch,00h,00h,00h,08Bh,00h,00h,00h
db 01Bh,00h,00h,00h
db 08Fh,00h,00h,00h,07Ch,00h,00h,00h,0A0h,00h,00h,00h
db 01Bh,00h,00h,00h
db 0A4h,00h,00h,00h,07Ch,00h,00h,00h,0B5h,00h,00h,00h,01Bh,00h,00h,00h
db 0B9h,00h,00h,00h,07Ch,00h,00h,00h,0CAh,00h,00h,00h
ctlboxrect1:
db 0Eh,00h,00h,00h,0D4h,00h,00h,00h,03Fh,00h,00h,00h,0E4h,00h,00h,00h
ctlboxrect2:
db 058h,00h,00h,00h,0D4h,00h,00h,00h,089h,00h,00h,00h,0E4h,00h,00h,00h
ctldlgalt:
db 00h,00h,00h,00h
str_BOS1:
db 042h,04Fh,053h,031h,00h
str_BOS22:
db 042h,04Fh,053h,032h,00h
str_BOS3:
db 042h,04Fh,053h,033h,00h
str_HART2:
db 048h,041h,052h,054h,032h,00h
str_BUF22:
db 042h,055h,046h,032h,00h
str_CAL1:
db 043h,041h,04Ch,031h,00h
str_CAL2:
db 043h,041h,04Ch,032h,00h
str_CAL3:
db 043h,041h,04Ch,033h,00h
str_CHIC1:
db 043h,048h,049h,043h,031h,00h
str_CHIC2:
db 043h,048h,049h,043h,032h,00h
str_CHIC3:
db 043h,048h,049h,043h,033h,00h
str_DET1:
db 044h,045h,054h,031h,00h
str_DET22:
db 044h,045h,054h,032h,00h
str_ED1:
db 045h,044h,031h,00h
str_HART1:
db 048h,041h,052h,054h,031h,00h
str_HART22:
db 048h,041h,052h,054h,032h,00h
str_HART3:
db 048h,041h,052h,054h,033h,00h
str_LA1:
db 04Ch,041h,031h,00h
str_LA4:
db 04Ch,041h,034h,00h
str_MON1:
db 04Dh,04Fh,04Eh,031h,00h
str_MON2:
db 04Dh,04Fh,04Eh,032h,00h
str_MON3:
db 04Dh,04Fh,04Eh,033h,00h
str_HART23:
db 048h,041h,052h,054h,032h,00h
str_NJER2:
db 04Eh,04Ah,045h,052h,032h,00h
str_LI2:
db 04Ch,049h,032h,00h
str_LI3:
db 04Ch,049h,033h,00h
str_NY3:
db 04Eh,059h,033h,00h
str_PHIL1:
db 050h,048h,049h,04Ch,031h,00h
str_PHIL2:
db 050h,048h,049h,04Ch,032h,00h
str_CGY22:
db 043h,047h,059h,032h,00h
str_PITTS1:
db 050h,049h,054h,054h,053h,031h,00h
str_PITTS2:
db 050h,049h,054h,054h,053h,032h,00h
str_PITTS3:
db 050h,049h,054h,054h,053h,033h,00h
str_PITTS4:
db 050h,049h,054h,054h,053h,034h,00h
str_QU1:
db 051h,055h,031h,00h
str_SL1:
db 053h,04Ch,031h,00h
str_SL2:
db 053h,04Ch,032h,00h
str_SL3:
db 053h,04Ch,033h,00h
str_SHK1:
db 053h,048h,04Bh,031h,00h
str_SHK2:
db 053h,048h,04Bh,032h,00h
str_MON12:
db 04Dh,04Fh,04Eh,031h,00h
str_MON32:
db 04Dh,04Fh,04Eh,033h,00h
str_LA42:
db 04Ch,041h,034h,00h
str_SHK7:
db 053h,048h,04Bh,037h,00h
str_SHK8:
db 053h,048h,04Bh,038h,00h
str_BOS23:
db 042h,04Fh,053h,032h,00h
str_TB22:
db 054h,042h,032h,00h
str_TOR1:
db 054h,04Fh,052h,031h,00h
str_TOR22:
db 054h,04Fh,052h,032h,00h
str_VAN1:
db 056h,041h,04Eh,031h,00h
str_VAN3:
db 056h,041h,04Eh,033h,00h
str_WASH3:
db 057h,041h,053h,048h,033h,00h
str_WINN2:
db 057h,049h,04Eh,04Eh,032h,00h
str_ROCKDITI2:
db 052h,04Fh,043h,04Bh,044h,049h,054h,049h,00h
rockcuefiles:
dd str_BOS1
dd str_BOS22
dd str_BOS3
dd str_HART2
dd str_BUF22
dd str_CAL1
dd str_CAL2
dd str_CAL3
dd str_CHIC1
dd str_CHIC2
dd str_CHIC3
dd str_DET1
dd str_DET22
dd str_ED1
dd str_HART1
dd str_HART22
dd str_HART3
dd str_LA1
dd str_LA4
dd str_MON1
dd str_MON2
dd str_MON3
dd str_HART23
dd str_NJER2
dd str_LI2
dd str_LI3
dd str_NY3
dd str_PHIL1
dd str_PHIL2
dd str_CGY22
dd str_PITTS1
dd str_PITTS2
dd str_PITTS3
dd str_PITTS4
dd str_QU1
dd str_SL1
dd str_SL2
dd str_SL3
dd str_SHK1
dd str_SHK2
dd str_MON12
dd str_MON32
dd str_LA42
dd str_SHK7
dd str_SHK8
dd str_BOS23
dd str_TB22
dd str_TOR1
dd str_TOR22
dd str_VAN1
dd str_VAN3
dd str_WASH3
dd str_WINN2
teamrockcuetbl equ $+1
dd str_ROCKDITI2
db 01h,00h,02h,0FFh,01Fh,01h,04h,0Fh,0Fh,04h,01Fh,0FFh,05h,07h,05h,07h
db 06h,06h,08h,0Ah,09h,08h,01Fh,02Bh,0Bh,0Ch,0Ah,0FFh,01Fh,0Ch,0Dh,01h
db 01h,0FFh,01Fh,0FFh,0Eh,010h,0Fh,010h,01Fh,0Eh,011h,011h,0Ah,07h,0FFh,012h
db 01h,018h,018h,0FFh,01Fh,0FFh,0Ch,015h,0Ch,014h,01Fh,013h,0Fh,017h,0Fh,0FFh
db 01Fh,0Bh,0Fh,018h,0Fh,019h,01Fh,019h,01h,01Ah,0Fh,0FFh,01Fh,0FFh,0Fh,034h
db 0Ch,0FFh,01Fh,0FFh,01Bh,01Ch,01Bh,06h,01Fh,06h,01Eh,020h,01Eh,021h,01Fh,021h
db 022h,06h,022h,0FFh,01Fh,06h,023h,024h,024h,023h,01Fh,025h,026h,027h,013h,015h
db 012h,02Bh,01h,02Eh,02Eh,0FFh,01Fh,0FFh,02Fh,02Fh,030h,0FFh,01Fh,0FFh,031h,026h
db 032h,0FFh,01Fh,0FFh,0Ch,033h,0Ch,0FFh,01Fh,0Ch,0Fh,034h,0Ch,0FFh,01Fh,0FFh
db 011h,02Fh,032h,0FFh,06h,02Bh,0Fh,020h,032h,0FFh,01Fh,013h,026h,06h,013h,015h
db 012h,02Bh,01h,01Ah,0Fh,0FFh,01Fh,0FFh
rockcuepool:
db 010h,00h,00h,00h,019h,00h,00h,00h,021h,00h,00h,00h,02Bh,00h,00h,00h
db 02Ch,00h,00h,00h,035h,00h,00h,00h,011h,00h,00h,00h,012h,00h,00h,00h
db 013h,00h,00h,00h,015h,00h,00h,00h,01Ch,00h,00h,00h,01Eh,00h,00h,00h
db 020h,00h,00h,00h,025h,00h,00h,00h,02Eh,00h,00h,00h,02Fh,00h,00h,00h
db 032h,00h,00h,00h,034h,00h,00h,00h
str_CANADA:
db 043h,041h,04Eh,041h,044h,041h,00h
str_USA:
db 055h,053h,041h,00h
teamtunefiles:
dd str_CANADA
dd str_USA
teamtunepathsel:
db 042h,00h,00h,00h,0B0h,01h,00h,00h
rockcuepathsel:
db 02Fh,00h,00h,00h,031h,00h,00h,00h,033h,00h,00h,00h,09Bh,00h,00h,00h
db 039h,00h,00h,00h,03Bh,00h,00h,00h,03Dh,00h,00h,00h,03Fh,00h,00h,00h
db 04Dh,00h,00h,00h,04Fh,00h,00h,00h,051h,00h,00h,00h,060h,00h,00h,00h
db 062h,00h,00h,00h,06Ch,00h,00h,00h,099h,00h,00h,00h,09Bh,00h,00h,00h
db 09Dh,00h,00h,00h,0E0h,00h,00h,00h,0E2h,00h,00h,00h,0F0h,00h,00h,00h
db 0F2h,00h,00h,00h,0F4h,00h,00h,00h,09Bh,00h,00h,00h,0Ah,01h,00h,00h
db 0E4h,00h,00h,00h,0E6h,00h,00h,00h,0Dh,01h,00h,00h,022h,01h,00h,00h
db 024h,01h,00h,00h,03Dh,00h,00h,00h,030h,01h,00h,00h,032h,01h,00h,00h
db 034h,01h,00h,00h,035h,01h,00h,00h,056h,01h,00h,00h,089h,01h,00h,00h
db 08Bh,01h,00h,00h,08Dh,01h,00h,00h,079h,01h,00h,00h,07Bh,01h,00h,00h
db 0F0h,00h,00h,00h,0F4h,00h,00h,00h,0E2h,00h,00h,00h,083h,01h,00h,00h
db 085h,01h,00h,00h,031h,00h,00h,00h,09Ch,01h,00h,00h,0A6h,01h,00h,00h
db 0A8h,01h,00h,00h,0B4h,01h,00h,00h,0B6h,01h,00h,00h,0B8h,01h,00h,00h
db 0BAh,01h,00h,00h,061h,01h,00h,00h,00h,00h
gadgetrects:
db 09Fh,00h,00h,00h
gadgetrect_y0:
db 0ACh,00h,00h,00h
gadgetrect_x1:
db 0AAh,00h,00h,00h
gadgetrect_y1:
db 0B4h,00h,00h,00h,092h,02h,00h,00h,08h,00h,00h,00h,01h,00h,00h,00h
db 0B3h,00h,00h,00h,0ACh,00h,00h,00h,0BEh,00h,00h,00h,0B4h,00h,00h,00h
db 098h,02h,00h,00h,00h,00h,00h,00h,02h,00h,00h,00h,0C6h,00h,00h,00h
db 0ACh,00h,00h,00h,0D1h,00h,00h,00h,0B4h,00h,00h,00h,09Eh,02h,00h,00h
db 01h,00h,00h,00h,03h,00h,00h,00h,0D9h,00h,00h,00h,0ACh,00h,00h,00h
db 0E4h,00h,00h,00h,0B4h,00h,00h,00h,0A4h,02h,00h,00h,02h,00h,00h,00h
db 04h,00h,00h,00h,0ECh,00h,00h,00h,0ACh,00h,00h,00h,0F7h,00h,00h,00h
db 0B4h,00h,00h,00h,0AAh,02h,00h,00h,03h,00h,00h,00h,05h,00h,00h,00h
db 0FFh,00h,00h,00h,0ACh,00h,00h,00h,0Ah,01h,00h,00h,0B4h,00h,00h,00h
db 0B0h,02h,00h,00h,04h,00h,00h,00h,06h,00h,00h,00h,09Fh,00h,00h,00h
db 0B9h,00h,00h,00h,0BEh,00h,00h,00h,0C1h,00h,00h,00h,0B9h,02h,00h,00h
db 05h,00h,00h,00h,07h,00h,00h,00h,0C6h,00h,00h,00h,0B9h,00h,00h,00h
db 0E5h,00h,00h,00h,0C1h,00h,00h,00h,0C6h,02h,00h,00h,06h,00h,00h,00h
db 08h,00h,00h,00h,0ECh,00h,00h,00h,0B9h,00h,00h,00h,0Bh,01h,00h,00h
db 0C1h,00h,00h,00h,0D2h,02h,00h,00h,07h,00h,00h,00h,00h,00h,00h,00h
db 0C6h,00h,00h,00h,0B9h,00h,00h,00h,0E5h,00h,00h,00h,0C1h,00h,00h,00h
db 0C6h,02h,00h,00h,06h,00h,00h,00h,08h,00h,00h,00h
str_InsufficientDiskSpaceTo2:
db 049h,06Eh,073h,075h,066h,066h,069h,063h,069h,065h,06Eh,074h,020h,064h,069h,073h
db 06Bh,020h,073h,070h,061h,063h,065h,020h,074h,06Fh,00h
str_SaveHilights:
db 073h,061h,076h,065h,020h,068h,069h,06Ch,069h,067h,068h,074h,073h,02Eh,00h
str_CurrentHilightNotSaved:
db 043h,075h,072h,072h,065h,06Eh,074h,020h,068h,069h,06Ch,069h,067h,068h,074h,020h
db 06Eh,06Fh,074h,020h,073h,061h,076h,065h,064h,02Eh,00h
msg_NoHilightSpace:
dd str_InsufficientDiskSpaceTo2
dd str_SaveHilights
dd str_CurrentHilightNotSaved
db 00h,00h,00h
str_ThereAreNoHilights:
db 054h,068h,065h,072h,065h,020h,061h,072h,065h,020h,06Eh,06Fh,020h,068h,069h,06Ch
db 069h,067h,068h,074h,073h,021h,00h
msg_NoHilights:
dd str_ThereAreNoHilights
str_ThereIsNotEnogh:
db 054h,068h,065h,072h,065h,020h,069h,073h,020h,06Eh,06Fh,074h,020h,065h,06Eh,06Fh
db 067h,068h,020h,073h,070h,061h,063h,065h,020h,06Fh,06Eh,00h
str_TheFloppyDiskFor:
db 074h,068h,065h,020h,066h,06Ch,06Fh,070h,070h,079h,020h,064h,069h,073h,06Bh,020h
db 066h,06Fh,072h,020h,074h,068h,065h,020h,068h,069h,06Ch,069h,067h,068h,074h,073h
db 021h,00h
str_SelectLessHilightsOr:
db 053h,065h,06Ch,065h,063h,074h,020h,06Ch,065h,073h,073h,020h,068h,069h,06Ch,069h
db 067h,068h,074h,073h,020h,06Fh,072h,020h,067h,065h,074h,020h,061h,06Eh,06Fh,074h
db 068h,065h,072h,020h,064h,069h,073h,06Bh,02Eh,00h
dd str_ThereIsNotEnogh
dd str_TheFloppyDiskFor
dd str_SelectLessHilightsOr
str_ThereIsNotEnogh2:
db 054h,068h,065h,072h,065h,020h,069h,073h,020h,06Eh,06Fh,074h,020h,065h,06Eh,06Fh
db 067h,068h,020h,073h,070h,061h,063h,065h,020h,06Fh,06Eh,00h
str_TheHardDiskFor:
db 074h,068h,065h,020h,068h,061h,072h,064h,020h,064h,069h,073h,06Bh,020h,066h,06Fh
db 072h,020h,074h,068h,065h,020h,068h,069h,06Ch,069h,067h,068h,074h,073h,021h,00h
str_TrySelectingLessHilights:
db 054h,072h,079h,020h,073h,065h,06Ch,065h,063h,074h,069h,06Eh,067h,020h,06Ch,065h
db 073h,073h,020h,068h,069h,06Ch,069h,067h,068h,074h,073h,02Eh,00h
dd str_ThereIsNotEnogh2
dd str_TheHardDiskFor
dd str_TrySelectingLessHilights
str_TheHilight:
db 054h,068h,065h,020h,068h,069h,06Ch,069h,067h,068h,074h,00h
str_AlreadyExists:
db 061h,06Ch,072h,065h,061h,064h,079h,020h,065h,078h,069h,073h,074h,073h,02Eh,00h
dd str_TheHilight
db 00h,00h,00h,00h
dd str_AlreadyExists
str_ExportingHilights:
db 045h,078h,070h,06Fh,072h,074h,069h,06Eh,067h,020h,068h,069h,06Ch,069h,067h,068h
db 074h,073h,00h,049h,06Dh,070h,06Fh,072h,074h,069h,06Eh,067h,020h,068h,069h,06Ch
db 069h,067h,068h,074h,073h,00h
dd str_ExportingHilights
str_HilightDescFmt:
db 025h,064h,020h,025h,064h,02Ch,020h,025h,073h,020h,076h,073h,020h,025h,073h,02Ch
db 020h,050h,065h,072h,069h,06Fh,064h,020h,025h,064h,02Ch,020h,054h,069h,06Dh,065h
db 020h,025h,030h,032h,064h,03Ah,025h,030h,032h,064h,02Eh,00h,00h,00h
settingsfile:
db 00h,00h,00h,00h
str_Exhibition2:
db 045h,078h,068h,069h,062h,069h,074h,069h,06Fh,06Eh,00h
str_Playoff:
db 050h,06Ch,061h,079h,06Fh,066h,066h,00h
str_League2:
db 04Ch,065h,061h,067h,075h,065h,00h
str_ShowLeague:
db 053h,068h,06Fh,077h,020h,04Ch,065h,061h,067h,075h,065h,00h
str_Settings3:
db 020h,053h,065h,074h,074h,069h,06Eh,067h,073h,020h,02Eh,02Eh,02Eh,00h
lockerindex:
db 01h,00h,00h,00h,02h,00h,00h,00h,03h,00h,00h,00h,04h,00h,00h,00h
db 06h,00h,00h,00h,07h,00h,00h,00h,09h,00h,00h,00h,0Ah,00h,00h,00h
db 05h,00h,00h,00h,0Bh,00h,00h,00h,0Ch,00h,00h,00h,0Dh,00h,00h,00h
db 0Eh,00h,00h,00h,0Fh,00h,00h,00h,010h,00h,00h,00h,011h,00h,00h,00h
db 012h,00h,00h,00h,013h,00h,00h,00h,014h,00h,00h,00h,015h,00h,00h,00h
db 016h,00h,00h,00h,017h,00h,00h,00h,018h,00h,00h,00h,019h,00h,00h,00h
db 00h,00h,00h,00h,08h,00h,00h,00h,01Ah,00h,00h,00h,01Bh,00h,00h,00h
lockerteams:
db 018h,00h,00h,00h,00h,00h,00h,00h,01h,00h,00h,00h,02h,00h,00h,00h
db 03h,00h,00h,00h,08h,00h,00h,00h,04h,00h,00h,00h,05h,00h,00h,00h
db 019h,00h,00h,00h,06h,00h,00h,00h,07h,00h,00h,00h,09h,00h,00h,00h
db 0Ah,00h,00h,00h,0Bh,00h,00h,00h,0Ch,00h,00h,00h,0Dh,00h,00h,00h
db 0Eh,00h,00h,00h,0Fh,00h,00h,00h,010h,00h,00h,00h,011h,00h,00h,00h
db 012h,00h,00h,00h,013h,00h,00h,00h,014h,00h,00h,00h,015h,00h,00h,00h
db 016h,00h,00h,00h,017h,00h,00h,00h,01Ah,00h,00h,00h,01Bh,00h,00h,00h
jerseyabbrevs:
dd str_ANA4
dd str_BOS2
dd str_BUF4
dd str_CGY2
dd str_CHI2
dd str_DAL2
dd str_DET2
dd str_EDM2
dd str_FLA2
dd str_HFD2
dd str_LA2
dd str_MTL2
dd str_NJ2
dd str_NYI2
dd str_NYR2
dd str_OTT2
dd str_PHI2
dd str_PIT2
dd str_QUE2
dd str_STL2
dd str_SJ2
dd str_TB2
dd str_TOR2
dd str_VAN2
dd str_WSH2
dd str_WPG2
dd str_ASW2
dd str_ASE2
poroundnames:
dd str_WesternConferenceQuarter
dd str_EasternConferenceQuarter
dd str_StanleyCupFinals
poroundnameidx:
db 0FFh,0FFh,0FFh,0FFh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 01h,00h,00h,00h,02h,00h,00h,00h,02h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh
db 01h,00h,00h,00h,02h,00h,00h,00h,02h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh
db 01h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
lockerrects:
db 023h,00h,00h,00h
db 046h,00h,00h,00h
db 040h,01h,00h,00h
db 090h,01h,00h,00h,059h,01h,00h,00h,046h,00h,00h,00h,076h,02h,00h,00h
db 090h,01h,00h,00h
db 095h,00h,00h,00h
db 0B0h,01h,00h,00h
db 0C4h,00h,00h,00h
db 0C4h,01h,00h,00h
db 0D9h,00h,00h,00h
db 0B0h,01h,00h,00h
db 08h,01h,00h,00h,0C4h,01h,00h,00h
db 079h,01h,00h,00h
db 0B0h,01h,00h,00h
db 0A8h,01h,00h,00h
db 0C4h,01h,00h,00h
db 0BDh,01h,00h,00h
db 0B0h,01h,00h,00h
db 0ECh,01h,00h,00h,0C4h,01h,00h,00h
lockeracceptx:
db 01Bh,02h,00h,00h
lockeraccepty:
db 0B7h,01h,00h,00h,06Bh,02h,00h,00h,0CBh,01h,00h,00h
lockercancelx:
db 015h,00h,00h,00h
lockercancely:
db 0B7h,01h,00h,00h,065h,00h,00h,00h,0CBh,01h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
dword_D2350:
db 00h,00h,00h,00h,02Eh,053h,043h,04Eh,00h,02Eh,050h,041h,054h,00h,02Eh,054h
db 049h,04Dh,00h,050h,043h,046h,046h,025h,030h,033h,064h,00h,050h,043h,00h
str_PCBEEP:
db 050h,043h,042h,045h,045h,050h,00h,053h,042h,00h
str_SBDAC:
db 053h,042h,044h,041h,043h,00h,059h,04Dh,00h
str_ADLIB:
db 041h,044h,04Ch,049h,042h,00h,04Dh,054h,00h
str_MT322:
db 04Dh,054h,033h,032h,00h
str_SBDAC2:
db 053h,042h,044h,041h,043h,00h,04Eh,04Ch,00h
str_PCBEEP2:
db 050h,043h,042h,045h,045h,050h,00h
str_PC:
db 050h,043h,00h
soundcardrects:
db 0Eh,00h,00h,00h
db 01Eh,00h,00h,00h
db 071h,00h,00h,00h
db 02Fh,00h,00h,00h,0Eh,00h,00h,00h,033h,00h,00h,00h,071h,00h,00h,00h
db 044h,00h,00h,00h,0Eh,00h,00h,00h,048h,00h,00h,00h,071h,00h,00h,00h
db 059h,00h,00h,00h,0Eh,00h,00h,00h,05Dh,00h,00h,00h,071h,00h,00h,00h
db 06Eh,00h,00h,00h,0Eh,00h,00h,00h,087h,00h,00h,00h,071h,00h,00h,00h
db 098h,00h,00h,00h,0Eh,00h,00h,00h,072h,00h,00h,00h,071h,00h,00h,00h
db 083h,00h,00h,00h
sndselbox1:
db 09h,00h,00h,00h,0A4h,00h,00h,00h,03Ah,00h,00h,00h,0B4h,00h,00h,00h
sndselbox2:
db 045h,00h,00h,00h,0A4h,00h,00h,00h,076h,00h,00h,00h,0B4h,00h,00h,00h
dword_D2423:
db 00h,00h,00h,00h
dword_D2427:
db 0FFh,0FFh,0FFh,0FFh
digidriver:
db 0FFh
db 0FFh,0FFh,0FFh
musicslot:
db 00h
musicon:
db 00h
musichandle:
db 00h,00h,00h,00h
sndtempbuf:
db 00h,00h,00h,00h
crowddriver:
db 00h
sounddevids:
db 010h,00h,00h,00h,01h,00h,00h,00h,04h,00h,00h,00h,02h,00h,00h,00h
db 08h,00h,00h,00h,020h,00h,00h,00h
str_CouldNotFindA:
db 043h,06Fh,075h,06Ch,064h,020h,06Eh,06Fh,074h,020h,066h,069h,06Eh,064h,020h,061h
db 00h
str_CardInThisMachine:
db 063h,061h,072h,064h,020h,069h,06Eh,020h,074h,068h,069h,073h,020h,06Dh,061h,063h
db 068h,069h,06Eh,065h,021h,00h
str_SoundBlaster2:
db 053h,06Fh,075h,06Eh,064h,042h,06Ch,061h,073h,074h,065h,072h,00h
str_Adlib:
db 041h,064h,06Ch,069h,062h,00h
str_MT323:
db 04Dh,054h,033h,032h,00h
str_ULTRASOUND:
db 055h,04Ch,054h,052h,041h,053h,04Fh,055h,04Eh,044h,00h
msg_NoSoundCard:
dd str_CouldNotFindA
sndcardname:
db 00h,00h,00h,00h
dd str_CardInThisMachine
str_InitializingTheMT32Card:
db 049h,06Eh,069h,074h,069h,061h,06Ch,069h,07Ah,069h,06Eh,067h,020h,074h,068h,065h
db 020h,04Dh,054h,033h,032h,020h,063h,061h,072h,064h,02Eh,00h
str_PleaseWait:
db 050h,06Ch,065h,061h,073h,065h,020h,077h,061h,069h,074h,02Eh,00h
msg_InitMT32:
dd str_InitializingTheMT32Card
dd str_PleaseWait
db 00h,00h,00h
str_SS5:
db 025h,073h,02Eh,025h,073h,00h
str_PauseCor:
db 070h,061h,075h,073h,065h,02Eh,063h,06Fh,072h,00h
str_AtCor:
db 061h,074h,02Eh,063h,06Fh,072h,00h
str_1minuteCor:
db 031h,06Dh,069h,06Eh,075h,074h,065h,02Eh,063h,06Fh,072h,00h
str_MinutesCor:
db 06Dh,069h,06Eh,075h,074h,065h,073h,02Eh,063h,06Fh,072h,00h
str_1secondCor:
db 031h,073h,065h,063h,06Fh,06Eh,064h,02Eh,063h,06Fh,072h,00h
str_SecondsCor:
db 073h,065h,063h,06Fh,06Eh,064h,073h,02Eh,063h,06Fh,072h,00h
str_PennumCor:
db 070h,065h,06Eh,06Eh,075h,06Dh,02Eh,063h,06Fh,072h,00h
str_PensnumCor:
db 070h,065h,06Eh,073h,06Eh,075h,06Dh,02Eh,063h,06Fh,072h,00h
str_PenshotCor:
db 070h,065h,06Eh,073h,068h,06Fh,074h,02Eh,063h,06Fh,072h,00h
str_GoalnumCor:
db 067h,06Fh,061h,06Ch,06Eh,075h,06Dh,02Eh,063h,06Fh,072h,00h
str_AsstnumCor:
db 061h,073h,073h,074h,06Eh,075h,06Dh,02Eh,063h,06Fh,072h,00h
str_AndnumCor:
db 061h,06Eh,064h,06Eh,075h,06Dh,02Eh,063h,06Fh,072h,00h
str_OneleftCor:
db 06Fh,06Eh,065h,06Ch,065h,066h,074h,02Eh,063h,06Fh,072h,00h
str_2minCor:
db 032h,06Dh,069h,06Eh,02Eh,063h,06Fh,072h,00h
str_5minCor:
db 035h,06Dh,069h,06Eh,02Eh,063h,06Fh,072h,00h
str_NumberCor:
db 06Eh,075h,06Dh,062h,065h,072h,02Eh,063h,06Fh,072h,00h,065h,061h,073h,070h,06Fh
db 072h,074h,073h,02Eh,069h,06Eh,074h,00h
str_NowbackInt:
db 06Eh,06Fh,077h,062h,061h,063h,06Bh,02Eh,069h,06Eh,074h,00h
str_BackmomtInt:
db 062h,061h,063h,06Bh,06Dh,06Fh,06Dh,074h,02Eh,069h,06Eh,074h,00h
str_CoachclpInt:
db 063h,06Fh,061h,063h,068h,063h,06Ch,070h,02Eh,069h,06Eh,074h,00h,06Eh,068h,06Ch
db 02Eh,069h,06Eh,074h,00h
str_OfBar:
db 06Fh,066h,02Eh,062h,061h,072h,00h,06Eh,075h,06Dh,062h,065h,072h,02Eh,062h,061h
db 072h,00h,064h,069h,076h,069h,073h,069h,06Fh,06Eh,02Eh,062h,061h,072h,00h,063h
db 06Fh,06Eh,066h,02Eh,062h,061h,072h,00h,066h,069h,06Eh,061h,06Ch,02Eh,062h,061h
db 072h,00h,073h,065h,06Dh,069h,02Eh,062h,061h,072h,00h
str_AndBar:
db 061h,06Eh,064h,02Eh,062h,061h,072h,00h
str_BetweenBar:
db 062h,065h,074h,077h,065h,065h,06Eh,02Eh,062h,061h,072h,00h
str_GamenumBar:
db 067h,061h,06Dh,065h,06Eh,075h,06Dh,02Eh,062h,061h,072h,00h
str_EasportsBar:
db 065h,061h,073h,070h,06Fh,072h,074h,073h,02Eh,062h,061h,072h,00h
str_TonightBar:
db 074h,06Fh,06Eh,069h,067h,068h,074h,02Eh,062h,061h,072h,00h
str_GamebtwnBar:
db 067h,061h,06Dh,065h,062h,074h,077h,06Eh,02Eh,062h,061h,072h,00h,070h,072h,065h
db 073h,065h,06Eh,074h,073h,02Eh,069h,06Eh,074h,00h,068h,06Fh,063h,06Bh,065h,079h
db 02Eh,069h,06Eh,074h,00h,069h,06Dh,072h,062h,061h,072h,072h,02Eh,069h,06Eh,074h
db 00h
str_GoodniteInt:
db 067h,06Fh,06Fh,064h,06Eh,069h,074h,065h,02Eh,069h,06Eh,074h,00h
str_LineupsInt:
db 06Ch,069h,06Eh,065h,075h,070h,073h,02Eh,069h,06Eh,074h,00h,065h,06Ch,073h,065h
db 077h,068h,065h,072h,02Eh,069h,06Eh,074h,00h,074h,06Fh,06Eh,069h,067h,068h,074h
db 02Eh,069h,06Eh,074h,00h
str_TakeynowBar:
db 074h,061h,06Bh,065h,079h,06Eh,06Fh,077h,02Eh,062h,061h,072h,00h
str_HighliteBar:
db 068h,069h,067h,068h,06Ch,069h,074h,065h,02Eh,062h,061h,072h,00h
str_OvertimeBar:
db 06Fh,076h,065h,072h,074h,069h,06Dh,065h,02Eh,062h,061h,072h,00h
str_HavewonBar:
db 068h,061h,076h,065h,077h,06Fh,06Eh,02Eh,062h,061h,072h,00h
str_Scor1perBar:
db 073h,063h,06Fh,072h,031h,070h,065h,072h,02Eh,062h,061h,072h,00h
str_Scor2perBar:
db 073h,063h,06Fh,072h,032h,070h,065h,072h,02Eh,062h,061h,072h,00h
str_Scor3perBar:
db 073h,063h,06Fh,072h,033h,070h,065h,072h,02Eh,062h,061h,072h,00h
str_Scor1otpBar:
db 073h,063h,06Fh,072h,031h,06Fh,074h,070h,02Eh,062h,061h,072h,00h
str_Scor2otpBar:
db 073h,063h,06Fh,072h,032h,06Fh,074h,070h,02Eh,062h,061h,072h,00h
str_Scor3otpBar:
db 073h,063h,06Fh,072h,033h,06Fh,074h,070h,02Eh,062h,061h,072h,00h
str_ScortotpBar:
db 073h,063h,06Fh,072h,074h,06Fh,074h,070h,02Eh,062h,061h,072h,00h
str_ThegameBar:
db 074h,068h,065h,067h,061h,06Dh,065h,02Eh,062h,061h,072h,00h
penaltyclips:
dd str_RoughingPen
dd str_ChargingPen
dd str_SlashingPen
dd str_XcheckPen
dd str_HookingPen
dd str_TrippingPen
dd str_InterferPen
dd str_HoldingPen
dd str_AbusePen
dd str_CheckbndPen
dd str_BoardingPen
dd str_ElbowingPen
dd str_HistickPen
dd str_SpearingPen
scorperclips:
dd str_Scor1perBar
dd str_Scor2perBar
dd str_Scor3perBar
str_1ststarCor:
db 031h,073h,074h,073h,074h,061h,072h,02Eh,063h,06Fh,072h,00h
str_2ndstarCor:
db 032h,06Eh,064h,073h,074h,061h,072h,02Eh,063h,06Fh,072h,00h
unk_D279A:
db 033h,072h,064h,073h,074h,061h,072h,02Eh
str_Cor2:
db 063h,06Fh,072h,00h
dd str_1ststarCor
dd str_2ndstarCor
dd unk_D279A
speechchannel:
db 00h,00h,00h,00h
byte_D27B6:
db 00h
speechcopylen:
db 00h,00h,00h,00h
speechinit:
db 00h,00h,00h,00h
str_VIV:
db 02Eh,056h,049h,056h,00h
str_SavingCurrent:
db 053h,061h,076h,069h,06Eh,067h,020h,043h,075h,072h,072h,065h,06Eh,074h,00h
str_LeagueGame:
db 04Ch,065h,061h,067h,075h,065h,020h,047h,061h,06Dh,065h,02Eh,00h
str_PlayOffGame:
db 050h,06Ch,061h,079h,02Dh,04Fh,066h,066h,020h,047h,061h,06Dh,065h,02Eh,00h
msg_SavingLeagueGame:
dd str_SavingCurrent
dd str_LeagueGame
msg_SavingPlayoffGame:
dd str_SavingCurrent
dd str_PlayOffGame
str_InsufficientDiskSpaceTo3:
db 049h,06Eh,073h,075h,066h,066h,069h,063h,069h,065h,06Eh,074h,020h,064h,069h,073h
db 06Bh,020h,073h,070h,061h,063h,065h,020h,074h,06Fh,020h,073h,061h,076h,065h,00h
str_AGameYouRequire3:
db 061h,020h,067h,061h,06Dh,065h,02Ch,020h,079h,06Fh,075h,020h,072h,065h,071h,075h
db 069h,072h,065h,020h,058h,058h,058h,020h,04Bh,062h,079h,074h,065h,073h,020h,020h
db 020h,00h
str_OfFreeDiskSpace2:
db 06Fh,066h,020h,066h,072h,065h,065h,020h,064h,069h,073h,06Bh,020h,073h,070h,061h
db 063h,065h,02Eh,00h
msg_NoSaveSpace:
dd str_InsufficientDiskSpaceTo3
dd str_AGameYouRequire3
dd str_OfFreeDiskSpace2
db 00h,00h,00h
