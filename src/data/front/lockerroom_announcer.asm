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
global str_ThegameBar, str_VIV, str_AGameYouRequire3, TeamJerseyBase, fadeend, fadeend2, jerseyremap
global jerseyremaptrim, jerseypalslot0, jerseypalslot1, jerseypalslot2, jerseypalslot3, musicslot, MusicOn, crowddriver
global SpeechInitMode, dbdlgrects
global lineslotx
global linesloty, LineEdPairX, LineEdPairY, LineEdFiveX, LineEdFiveY, LineEdFourX, LineEdFourY, LineEdExtraX
global LineEdExtraY, LineEdGoalieX, LineEdGoalieY, jerseydigits, leaguesetrects
global modesetrects, exhsetrects
global ctldlgrects
global ctldlgalt, rockcuepool, teamtunepathsel, rockcuepathsel, gadgetrects, gadgetrect_y0, gadgetrect_x1, gadgetrect_y1
global settingsfile, lockerindex, lockerteams, poroundnameidx, lockerrects
global lockeracceptx, lockeraccepty
global lockercancelx, lockercancely, PcSpkSampleReady, soundcardrects, SoundDevActive
global musicdriver, digidriver, musichandle, sndtempbuf, sounddevids, sndcardname, str_Cor2
global speechchannel, speechcopylen, speechinit, dbtablists, rockcuefiles, teamrockcuetbl, teamtunefiles, msg_NoHilightSpace
global jerseyabbrevs, poroundnames, msg_InitMT32, penaltyclips, scorperclips, msg_SavingLeagueGame, msg_SavingPlayoffGame, msg_NoSaveSpace
global str_ConfirmDeletionOfThe2, deldbmsg, jerseyremapteam, dlggreys, ctlboxrect1, ctlboxrect2, str_BOS1, str_BOS22
global str_BOS3, str_HART2, str_BUF22, str_CAL1, str_CAL2, str_CAL3, str_CHIC1, str_CHIC2
global str_CHIC3, str_DET1, str_DET22, str_ED1, str_HART1, str_HART22, str_HART3, str_LA1
global str_LA4, str_MON1, str_MON2, str_MON3, str_HART23, str_NJER2, str_LI2, str_LI3
global str_NY3, str_PHIL1, str_PHIL2, str_CGY22, str_PITTS1, str_PITTS2, str_PITTS3, str_PITTS4
global str_QU1, str_SL1, str_SL2, str_SL3, str_SHK1, str_SHK2, str_MON12, str_MON32
global str_LA42, str_SHK7, str_SHK8, str_BOS23, str_TB22, str_TOR1, str_TOR22, str_VAN1
global str_VAN3, str_WASH3, str_WINN2, str_ROCKDITI2, str_CANADA, str_USA, str_InsufficientDiskSpaceTo2, str_SaveHilights
global str_CurrentHilightNotSaved, str_ThereAreNoHilights, msg_NoHilights, str_ThereIsNotEnogh, str_TheFloppyDiskFor, str_SelectLessHilightsOr, str_ThereIsNotEnogh2, str_TheHardDiskFor
global str_TrySelectingLessHilights, str_TheHilight, str_AlreadyExists, str_ExportingHilights, str_PC, sndselbox1, sndselbox2, str_CouldNotFindA
global str_CardInThisMachine, msg_NoSoundCard, str_InitializingTheMT32Card, str_PleaseWait, str_1ststarCor, str_2ndstarCor, str_3rdstar, str_SavingCurrent
global str_LeagueGame, str_PlayOffGame, str_InsufficientDiskSpaceTo3, str_OfFreeDiskSpace2
dbdlgrects:                                     ; [16] hit rects x1, y1, x2, y2 (rows at +0A0h); used by
                                                ; DbDialogHitTest, DbDialogLoop, DrawDbDialog ...
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
dbtablists:                                     ; list struct per tab (cur, orig, temp); used by DbDialogLoop,
                                                ; DrawDbDialog
        dd dblistcur
        dd dblistorig
        dd dblisttemp
str_ConfirmDeletionOfThe2:                      ; "Confirm deletion of the database:" string literal
        db 043h,06Fh,06Eh,066h,069h,072h,06Dh,020h,064h,065h,06Ch,065h,074h,069h,06Fh,06Eh
        db 020h,06Fh,066h,020h,074h,068h,065h,020h,064h,061h,074h,061h,062h,061h,073h,065h
        db 03Ah,00h
deldbmsg:                                       ; "Confirm deletion of the database:" <name>; used by
                                                ; DeleteSelectedDb
        dd str_ConfirmDeletionOfThe2
        db 00h,00h,00h,00h,00h,00h
TeamJerseyBase:                                 ; Palette index of each team's jersey base colour (dword per
                                                ; team); used by DbLineEditorLoop, DrawGameLineJerseys,
                                                ; DrawLineJerseys ...
        db 0ADh,00h,00h,00h,0ADh,00h,00h,00h,0AAh,00h,00h,00h,0B0h,00h,00h,00h
        db 0AAh,00h,00h,00h,0AAh,00h,00h,00h,0ADh,00h,00h,00h,0ADh,00h,00h,00h
        db 0A2h,00h,00h,00h,0ADh,00h,00h,00h,0ADh,00h,00h,00h,0AAh,00h,00h,00h
        db 0AAh,00h,00h,00h,090h,00h,00h,00h,090h,00h,00h,00h,0ADh,00h,00h,00h
        db 0B0h,00h,00h,00h,0ACh,00h,00h,00h,0ADh,00h,00h,00h,0AEh,00h,00h,00h
        db 0AAh,00h,00h,00h,0B0h,00h,00h,00h,0ADh,00h,00h,00h,0ADh,00h,00h,00h
        db 0AAh,00h,00h,00h,0AAh,00h,00h,00h,0BCh,00h,00h,00h,09Ch
        db 00h,00h
        db 00h
fadestart:                                      ; FadePalStep start value per direction (word table indexed by
                                                ; edi; [0]+1 patched to steps-1); used by FadePalStep
        db 01h
        db 0Fh
fadestep:                                       ; FadePalStep step per direction (+1/-1); used by FadePalStep
        db 01h
        db 0FFh
fadeend:                                        ; FadePalStep end value per direction (word table, [edi]
                                                ; index; [1] patched to steps+1); used by FadePalStep
        db 011h
        db 0FFh
fadestart2:                                     ; FadePalStepSlow start value per direction; used by
                                                ; FadePalStepSlow
        db 01h
        db 0Fh
fadestep2:                                      ; FadePalStepSlow step per direction; used by FadePalStepSlow
        db 01h,0FFh
fadeend2:                                       ; FadePalStepSlow end value per direction; used by
                                                ; FadePalStepSlow
        db 011h,0FFh
jerseyremap:                                    ; 256-byte palette remap table (identity init) filled per team
                                                ; and passed to MakeJerseyShape / SetColorRemap by the line
                                                ; editors and trade screen; used by DbLineEditorLoop,
                                                ; DrawGameLineJerseys, DrawLineJerseys ...
        db 00h,01h,02h,03h,04h,05h,06h,07h,08h,09h,0Ah,0Bh,0Ch,0Dh,0Eh,0Fh
        db 010h,011h,012h,013h,014h,015h,016h,017h,018h,019h,01Ah,01Bh,01Ch,01Dh,01Eh,01Fh
        db 020h,021h,022h,023h,024h,025h,026h,027h,028h,029h,02Ah,02Bh,02Ch,02Dh,02Eh,02Fh
        db 030h,031h,032h,033h,034h,035h,036h,037h,038h,039h,03Ah,03Bh,03Ch,03Dh,03Eh,03Fh
        db 040h,041h,042h,043h,044h,045h,046h,047h,048h,049h,04Ah,04Bh,04Ch,04Dh,04Eh,04Fh
        db 050h,051h,052h,053h,054h,055h,056h,057h,058h,059h,05Ah,05Bh,05Ch,05Dh,05Eh,05Fh
        db 060h,061h,062h,063h,064h,065h,066h,067h,068h,069h,06Ah,06Bh,06Ch,06Dh,06Eh,06Fh
        db 070h,071h,072h,073h,074h,075h,076h,077h,078h,079h,07Ah,07Bh,07Ch,07Dh,07Eh,07Fh
        db 080h,081h,082h,083h,084h,085h,086h,087h,088h,089h,08Ah,08Bh,08Ch,08Dh,08Eh,08Fh
jerseyremapteam:                                ; Team colour part of jerseyremap (entries 90h to BFh); used
                                                ; by DrawTradeScreen, TradeScreenLoop
        db 090h,091h,092h,093h,094h,095h,096h,097h,098h,099h,09Ah,09Bh,09Ch,09Dh,09Eh,09Fh
        db 0A0h,0A1h,0A2h,0A3h,0A4h,0A5h
jerseyremaptrim:                                ; jerseyremap entry A6h: the trim colour the line editors
                                                ; read; used by DbLineEditorLoop, DrawGameLineJerseys,
                                                ; DrawLineJerseys ...
        db 0A6h,0A7h,0A8h,0A9h,0AAh,0ABh,0ACh,0ADh,0AEh,0AFh,0B0h,0B1h,0B2h,0B3h,0B4h,0B5h
        db 0B6h,0B7h,0B8h,0B9h,0BAh,0BBh,0BCh,0BDh,0BEh,0BFh,0C0h,0C1h,0C2h,0C3h,0C4h,0C5h
        db 0C6h,0C7h,0C8h,0C9h,0CAh,0CBh,0CCh,0CDh,0CEh,0CFh,0D0h,0D1h,0D2h,0D3h,0D4h,0D5h
        db 0D6h,0D7h,0D8h,0D9h,0DAh,0DBh,0DCh,0DDh,0DEh,0DFh,0E0h,0E1h,0E2h,0E3h,0E4h,0E5h
        db 0E6h,0E7h,0E8h,0E9h,0EAh,0EBh,0ECh,0EDh,0EEh,0EFh,0F0h,0F1h,0F2h,0F3h,0F4h,0F5h
        db 0F6h,0F7h,0F8h,0F9h,0FAh
jerseypalslot0:                                 ; first of four palette slots the jersey shapes use (FBh game
                                                ; lines, 7Bh trade); used by LoadJerseyColours,
                                                ; LoadTradeTeamPals
        db 0FBh
jerseypalslot1:                                 ; second jersey palette slot; used by LoadJerseyColours,
                                                ; LoadTradeTeamPals
        db 0FCh
jerseypalslot2:                                 ; third jersey palette slot; used by LoadJerseyColours,
                                                ; LoadTradeTeamPals
        db 0FDh
jerseypalslot3:                                 ; fourth jersey palette slot; used by LoadJerseyColours,
                                                ; LoadTradeTeamPals
        db 0FEh,0FFh
lineslotx:                                      ; [40] line slot x (8-byte x, y pairs); used by
                                                ; DbLineEditorLoop, DrawGameLineJerseys, DrawLineJerseys ...
        db 047h,00h,00h,00h
linesloty:                                      ; [40] line slot y; used by DbLineEditorLoop,
                                                ; DrawGameLineJerseys, DrawLineJerseys ...
        db 028h,00h,00h,00h,083h,00h,00h,00h,028h,00h,00h,00h,0BFh,00h,00h,00h
        db 028h,00h,00h,00h,047h,00h,00h,00h,059h,00h,00h,00h,083h,00h,00h,00h
        db 059h,00h,00h,00h,0BFh,00h,00h,00h,059h,00h,00h,00h,047h,00h,00h,00h
        db 08Ah,00h,00h,00h,083h,00h,00h,00h,08Ah,00h,00h,00h,0BFh,00h,00h,00h
        db 08Ah,00h,00h,00h,047h,00h,00h,00h,0BBh,00h,00h,00h,083h,00h,00h,00h
        db 0BBh,00h,00h,00h,0BFh,00h,00h,00h,0BBh,00h,00h,00h
LineEdPairX:                                    ; Line editor jersey X for the two-slot rows (two per page);
                                                ; used by DbLineEditorLoop, GameLineEditorLoop
        db 056h,01h,00h,00h
LineEdPairY:                                    ; Line editor jersey Y for the two-slot rows; used by
                                                ; DbLineEditorLoop, GameLineEditorLoop
        db 028h,00h,00h,00h,092h,01h,00h,00h,028h,00h,00h,00h,056h,01h,00h,00h
        db 059h,00h,00h,00h,092h,01h,00h,00h,059h,00h,00h,00h,056h,01h,00h,00h
        db 08Ah,00h,00h,00h,092h,01h,00h,00h,08Ah,00h,00h,00h
LineEdFiveX:                                    ; Line editor jersey X for the five-player lines; used by
                                                ; DbLineEditorLoop, GameLineEditorLoop
        db 047h,00h,00h,00h
LineEdFiveY:                                    ; Line editor jersey Y for the five-player lines; used by
                                                ; DbLineEditorLoop, GameLineEditorLoop
        db 0F6h,00h,00h,00h,083h,00h,00h,00h,0F6h,00h,00h,00h,0BFh,00h,00h,00h
        db 0F6h,00h,00h,00h,0FBh,00h,00h,00h,0F6h,00h,00h,00h,037h,01h,00h,00h
        db 0F6h,00h,00h,00h,047h,00h,00h,00h,027h,01h,00h,00h,083h,00h,00h,00h
        db 027h,01h,00h,00h,0BFh,00h,00h,00h,027h,01h,00h,00h,0FBh,00h,00h,00h
        db 027h,01h,00h,00h,037h,01h,00h,00h,027h,01h,00h,00h
LineEdFourX:                                    ; Line editor jersey X for the four-player units; used by
                                                ; DbLineEditorLoop, GameLineEditorLoop
        db 047h,00h,00h,00h
LineEdFourY:                                    ; Line editor jersey Y for the four-player units; used by
                                                ; DbLineEditorLoop, GameLineEditorLoop
        db 062h,01h,00h,00h,083h,00h,00h,00h,062h,01h,00h,00h,0BFh,00h,00h,00h
        db 062h,01h,00h,00h,0FBh,00h,00h,00h,062h,01h,00h,00h,047h,00h,00h,00h
        db 093h,01h,00h,00h,083h,00h,00h,00h,093h,01h,00h,00h,0BFh,00h,00h,00h
        db 093h,01h,00h,00h,0FBh,00h,00h,00h,093h,01h,00h,00h
LineEdExtraX:                                   ; Line editor jersey X for the first fixed pair of slots; used
                                                ; by DbLineEditorLoop, GameLineEditorLoop
        db 099h,01h,00h,00h
LineEdExtraY:                                   ; Line editor jersey Y for the first fixed pair of slots; used
                                                ; by DbLineEditorLoop, GameLineEditorLoop
        db 0F5h,00h,00h,00h,099h,01h,00h,00h,022h,01h,00h,00h
LineEdGoalieX:                                  ; Line editor jersey X for the second fixed pair of slots;
                                                ; used by DbLineEditorLoop, GameLineEditorLoop
        db 063h,01h,00h,00h
LineEdGoalieY:                                  ; Line editor jersey Y for the second fixed pair of slots;
                                                ; used by DbLineEditorLoop, GameLineEditorLoop
        db 093h,01h,00h,00h,09Fh,01h,00h,00h,093h,01h,00h,00h
jerseydigits:                                   ; 1-bit digit glyphs (0Ch bytes each); used by BlitJerseyDigit
        db 0FEh,0F7h,0FFh,01h,018h,080h,01h,0F8h,0FFh,0FEh,07h,00h,00h,00h,00h,02h
        db 0F8h,0FFh,0FFh,0Fh,080h,00h,00h,00h,06h,07Fh,0F8h,0C1h,019h,08Eh,071h,0F8h
        db 0C3h,01Eh,0Ch,00h,06h,076h,0E0h,061h,018h,086h,061h,0F8h,0FFh,09Eh,07h,00h
        db 0F0h,080h,0Fh,0CCh,060h,0Ch,0C3h,0FFh,0FFh,0C0h,00h,00h,03Fh,0F6h,0E3h,031h
        db 018h,083h,031h,038h,0FFh,0C3h,07h,00h,0FEh,0F7h,0FFh,061h,018h,086h,061h,078h
        db 0FEh,086h,07h,00h,07h,070h,00h,01h,01Eh,0FEh,0FDh,0F3h,03h,07h,00h,00h
        db 09Eh,0F7h,0FFh,061h,018h,086h,061h,0F8h,0FFh,09Eh,07h,00h,01Eh,0F6h,0E7h,061h
        db 018h,086h,061h,0F8h,0FFh,0FEh,07h,00h
leaguesetrects:                                 ; 16-byte rects x0,y0,x1,y1; used by DrawLeagueSetChecks,
                                                ; LeagueSetHitTest
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
dlggreys:                                       ; four grey RGB triplets the settings dialogs load at colour
                                                ; F7h; used by ExhSetEditLoop, LeagueSetEditLoop,
                                                ; LeagueSetViewLoop ...
        db 00h,00h,00h,014h,014h,014h,02Eh,02Eh,02Eh,03Fh,03Fh,03Fh
modesetrects:                                   ; rects; used by DrawModeSetChecks, ModeSetHitTest
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
exhsetrects:                                    ; rects; used by DrawExhSetChecks, ExhSetHitTest
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
ctldlgrects:                                    ; rects; used by CtlDlgHitTest, DrawControlsDlg,
                                                ; DrawControlsOpts ...
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
ctlboxrect1:                                    ; ControlsDlgLoop: rectangle of the first highlighted box;
                                                ; used by ControlsDlgLoop
        db 0Eh,00h,00h,00h,0D4h,00h,00h,00h,03Fh,00h,00h,00h,0E4h,00h,00h,00h
ctlboxrect2:                                    ; ControlsDlgLoop: rectangle of the second highlighted box;
                                                ; used by ControlsDlgLoop
        db 058h,00h,00h,00h,0D4h,00h,00h,00h,089h,00h,00h,00h,0E4h,00h,00h,00h
ctldlgalt:                                      ; alternate colour flag for controller dialog; used by
                                                ; ControlsDlgExh, ControlsDlgLeague, DrawControlsDlg ...
        db 00h,00h,00h,00h
str_BOS1:                                       ; "BOS1" string literal
        db 042h,04Fh,053h,031h,00h
str_BOS22:                                      ; "BOS2" string literal
        db 042h,04Fh,053h,032h,00h
str_BOS3:                                       ; "BOS3" string literal
        db 042h,04Fh,053h,033h,00h
str_HART2:                                      ; "HART2" string literal
        db 048h,041h,052h,054h,032h,00h
str_BUF22:                                      ; "BUF2" string literal
        db 042h,055h,046h,032h,00h
str_CAL1:                                       ; "CAL1" string literal
        db 043h,041h,04Ch,031h,00h
str_CAL2:                                       ; "CAL2" string literal
        db 043h,041h,04Ch,032h,00h
str_CAL3:                                       ; "CAL3" string literal
        db 043h,041h,04Ch,033h,00h
str_CHIC1:                                      ; "CHIC1" string literal
        db 043h,048h,049h,043h,031h,00h
str_CHIC2:                                      ; "CHIC2" string literal
        db 043h,048h,049h,043h,032h,00h
str_CHIC3:                                      ; "CHIC3" string literal
        db 043h,048h,049h,043h,033h,00h
str_DET1:                                       ; "DET1" string literal
        db 044h,045h,054h,031h,00h
str_DET22:                                      ; "DET2" string literal
        db 044h,045h,054h,032h,00h
str_ED1:                                        ; "ED1" string literal
        db 045h,044h,031h,00h
str_HART1:                                      ; "HART1" string literal
        db 048h,041h,052h,054h,031h,00h
str_HART22:                                     ; "HART2" string literal
        db 048h,041h,052h,054h,032h,00h
str_HART3:                                      ; "HART3" string literal
        db 048h,041h,052h,054h,033h,00h
str_LA1:                                        ; "LA1" string literal
        db 04Ch,041h,031h,00h
str_LA4:                                        ; "LA4" string literal
        db 04Ch,041h,034h,00h
str_MON1:                                       ; "MON1" string literal
        db 04Dh,04Fh,04Eh,031h,00h
str_MON2:                                       ; "MON2" string literal
        db 04Dh,04Fh,04Eh,032h,00h
str_MON3:                                       ; "MON3" string literal
        db 04Dh,04Fh,04Eh,033h,00h
str_HART23:                                     ; "HART2" string literal
        db 048h,041h,052h,054h,032h,00h
str_NJER2:                                      ; "NJER2" string literal
        db 04Eh,04Ah,045h,052h,032h,00h
str_LI2:                                        ; "LI2" string literal
        db 04Ch,049h,032h,00h
str_LI3:                                        ; "LI3" string literal
        db 04Ch,049h,033h,00h
str_NY3:                                        ; "NY3" string literal
        db 04Eh,059h,033h,00h
str_PHIL1:                                      ; "PHIL1" string literal
        db 050h,048h,049h,04Ch,031h,00h
str_PHIL2:                                      ; "PHIL2" string literal
        db 050h,048h,049h,04Ch,032h,00h
str_CGY22:                                      ; "CGY2" string literal
        db 043h,047h,059h,032h,00h
str_PITTS1:                                     ; "PITTS1" string literal
        db 050h,049h,054h,054h,053h,031h,00h
str_PITTS2:                                     ; "PITTS2" string literal
        db 050h,049h,054h,054h,053h,032h,00h
str_PITTS3:                                     ; "PITTS3" string literal
        db 050h,049h,054h,054h,053h,033h,00h
str_PITTS4:                                     ; "PITTS4" string literal
        db 050h,049h,054h,054h,053h,034h,00h
str_QU1:                                        ; "QU1" string literal
        db 051h,055h,031h,00h
str_SL1:                                        ; "SL1" string literal
        db 053h,04Ch,031h,00h
str_SL2:                                        ; "SL2" string literal
        db 053h,04Ch,032h,00h
str_SL3:                                        ; "SL3" string literal
        db 053h,04Ch,033h,00h
str_SHK1:                                       ; "SHK1" string literal
        db 053h,048h,04Bh,031h,00h
str_SHK2:                                       ; "SHK2" string literal
        db 053h,048h,04Bh,032h,00h
str_MON12:                                      ; "MON1" string literal
        db 04Dh,04Fh,04Eh,031h,00h
str_MON32:                                      ; "MON3" string literal
        db 04Dh,04Fh,04Eh,033h,00h
str_LA42:                                       ; "LA4" string literal
        db 04Ch,041h,034h,00h
str_SHK7:                                       ; "SHK7" string literal
        db 053h,048h,04Bh,037h,00h
str_SHK8:                                       ; "SHK8" string literal
        db 053h,048h,04Bh,038h,00h
str_BOS23:                                      ; "BOS2" string literal
        db 042h,04Fh,053h,032h,00h
str_TB22:                                       ; "TB2" string literal
        db 054h,042h,032h,00h
str_TOR1:                                       ; "TOR1" string literal
        db 054h,04Fh,052h,031h,00h
str_TOR22:                                      ; "TOR2" string literal
        db 054h,04Fh,052h,032h,00h
str_VAN1:                                       ; "VAN1" string literal
        db 056h,041h,04Eh,031h,00h
str_VAN3:                                       ; "VAN3" string literal
        db 056h,041h,04Eh,033h,00h
str_WASH3:                                      ; "WASH3" string literal
        db 057h,041h,053h,048h,033h,00h
str_WINN2:                                      ; "WINN2" string literal
        db 057h,049h,04Eh,04Eh,032h,00h
str_ROCKDITI2:                                  ; "ROCKDITI" string literal
        db 052h,04Fh,043h,04Bh,044h,049h,054h,049h,00h
rockcuefiles:                                   ; cue file name pointers; used by LoadRockMusic
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
rockcuepool:                                    ; 18 random cue ids; used by LoadRockMusic
        db 010h,00h,00h,00h,019h,00h,00h,00h,021h,00h,00h,00h,02Bh,00h,00h,00h
        db 02Ch,00h,00h,00h,035h,00h,00h,00h,011h,00h,00h,00h,012h,00h,00h,00h
        db 013h,00h,00h,00h,015h,00h,00h,00h,01Ch,00h,00h,00h,01Eh,00h,00h,00h
        db 020h,00h,00h,00h,025h,00h,00h,00h,02Eh,00h,00h,00h,02Fh,00h,00h,00h
        db 032h,00h,00h,00h,034h,00h,00h,00h
str_CANADA:                                     ; "CANADA" string literal
        db 043h,041h,04Eh,041h,044h,041h,00h
str_USA:                                        ; "USA" string literal
        db 055h,053h,041h,00h
teamtunefiles:                                  ; team tune file name pointers; used by LoadRockMusic
        dd str_CANADA
        dd str_USA
teamtunepathsel:                                ; per-tune path flag index; used by LoadRockMusic
        db 042h,00h,00h,00h,0B0h,01h,00h,00h
rockcuepathsel:                                 ; used by LoadRockMusic
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
gadgetrects:                                    ; gadget button rects (28-byte entries) x0; used by
                                                ; DrawGadgetButton, GadgetHitTest
        db 09Fh,00h,00h,00h
gadgetrect_y0:                                  ; rect y0 (own label: nosplit); used by DrawGadgetButton,
                                                ; GadgetHitTest
        db 0ACh,00h,00h,00h
gadgetrect_x1:                                  ; rect x1 (own label: nosplit); used by DrawGadgetButton,
                                                ; GadgetHitTest
        db 0AAh,00h,00h,00h
gadgetrect_y1:                                  ; rect y1 (own label: nosplit); used by DrawGadgetButton,
                                                ; GadgetHitTest
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
str_InsufficientDiskSpaceTo2:                   ; "Insufficient disk space to" string literal
        db 049h,06Eh,073h,075h,066h,066h,069h,063h,069h,065h,06Eh,074h,020h,064h,069h,073h
        db 06Bh,020h,073h,070h,061h,063h,065h,020h,074h,06Fh,00h
str_SaveHilights:                               ; "save hilights." string literal
        db 073h,061h,076h,065h,020h,068h,069h,06Ch,069h,067h,068h,074h,073h,02Eh,00h
str_CurrentHilightNotSaved:                     ; "Current hilight not saved." string literal
        db 043h,075h,072h,072h,065h,06Eh,074h,020h,068h,069h,06Ch,069h,067h,068h,074h,020h
        db 06Eh,06Fh,074h,020h,073h,061h,076h,065h,064h,02Eh,00h
msg_NoHilightSpace:                             ; message lines 'Insufficient disk space to' / 'save
                                                ; hilights.' / 'Current hilight not saved.'; used by
                                                ; ReplaySaveHilight, ReplaySaveHilight_n3
        dd str_InsufficientDiskSpaceTo2
        dd str_SaveHilights
        dd str_CurrentHilightNotSaved
        db 00h,00h,00h
str_ThereAreNoHilights:                         ; "There are no hilights!" string literal
        db 054h,068h,065h,072h,065h,020h,061h,072h,065h,020h,06Eh,06Fh,020h,068h,069h,06Ch
        db 069h,067h,068h,074h,073h,021h,00h
msg_NoHilights:                                 ; message 'There are no hilights!'; used by SelectHilight
        dd str_ThereAreNoHilights
str_ThereIsNotEnogh:                            ; "There is not enogh space on" string literal
        db 054h,068h,065h,072h,065h,020h,069h,073h,020h,06Eh,06Fh,074h,020h,065h,06Eh,06Fh
        db 067h,068h,020h,073h,070h,061h,063h,065h,020h,06Fh,06Eh,00h
str_TheFloppyDiskFor:                           ; "the floppy disk for the hilights!" string literal
        db 074h,068h,065h,020h,066h,06Ch,06Fh,070h,070h,079h,020h,064h,069h,073h,06Bh,020h
        db 066h,06Fh,072h,020h,074h,068h,065h,020h,068h,069h,06Ch,069h,067h,068h,074h,073h
        db 021h,00h
str_SelectLessHilightsOr:                       ; "Select less hilights or get another disk." string literal
        db 053h,065h,06Ch,065h,063h,074h,020h,06Ch,065h,073h,073h,020h,068h,069h,06Ch,069h
        db 067h,068h,074h,073h,020h,06Fh,072h,020h,067h,065h,074h,020h,061h,06Eh,06Fh,074h
        db 068h,065h,072h,020h,064h,069h,073h,06Bh,02Eh,00h
        dd str_ThereIsNotEnogh
        dd str_TheFloppyDiskFor
        dd str_SelectLessHilightsOr
str_ThereIsNotEnogh2:                           ; "There is not enogh space on" string literal
        db 054h,068h,065h,072h,065h,020h,069h,073h,020h,06Eh,06Fh,074h,020h,065h,06Eh,06Fh
        db 067h,068h,020h,073h,070h,061h,063h,065h,020h,06Fh,06Eh,00h
str_TheHardDiskFor:                             ; "the hard disk for the hilights!" string literal
        db 074h,068h,065h,020h,068h,061h,072h,064h,020h,064h,069h,073h,06Bh,020h,066h,06Fh
        db 072h,020h,074h,068h,065h,020h,068h,069h,06Ch,069h,067h,068h,074h,073h,021h,00h
str_TrySelectingLessHilights:                   ; "Try selecting less hilights." string literal
        db 054h,072h,079h,020h,073h,065h,06Ch,065h,063h,074h,069h,06Eh,067h,020h,06Ch,065h
        db 073h,073h,020h,068h,069h,06Ch,069h,067h,068h,074h,073h,02Eh,00h
        dd str_ThereIsNotEnogh2
        dd str_TheHardDiskFor
        dd str_TrySelectingLessHilights
str_TheHilight:                                 ; "The hilight" string literal
        db 054h,068h,065h,020h,068h,069h,06Ch,069h,067h,068h,074h,00h
str_AlreadyExists:                              ; "already exists." string literal
        db 061h,06Ch,072h,065h,061h,064h,079h,020h,065h,078h,069h,073h,074h,073h,02Eh,00h
        dd str_TheHilight
        db 00h,00h,00h,00h
        dd str_AlreadyExists
str_ExportingHilights:                          ; "Exporting hilights" string literal
        db 045h,078h,070h,06Fh,072h,074h,069h,06Eh,067h,020h,068h,069h,06Ch,069h,067h,068h
        db 074h,073h,00h,049h,06Dh,070h,06Fh,072h,074h,069h,06Eh,067h,020h,068h,069h,06Ch
        db 069h,067h,068h,074h,073h,00h
        dd str_ExportingHilights
str_HilightDescFmt:                             ; string '%d %d, %s vs %s, Period %d, Time %02d:%02d.'; used
                                                ; by FormatHilightDesc
        db 025h,064h,020h,025h,064h,02Ch,020h,025h,073h,020h,076h,073h,020h,025h,073h,02Ch
        db 020h,050h,065h,072h,069h,06Fh,064h,020h,025h,064h,02Ch,020h,054h,069h,06Dh,065h
        db 020h,025h,030h,032h,064h,03Ah,025h,030h,032h,064h,02Eh,00h,00h,00h
settingsfile:                                   ; loaded "settings" PPV file (0 = not loaded); used by
                                                ; LeagueSettingsDlg, LoadSettingsShapes,
                                                ; MenuExhibitionSettings ...
        db 00h,00h,00h,00h
str_Exhibition2:                                ; string 'Exhibition'; used by DrawSettingsHeading_n1,
                                                ; SetModeMenuLabels
        db 045h,078h,068h,069h,062h,069h,074h,069h,06Fh,06Eh,00h
str_Playoff:                                    ; string 'Playoff'; used by DrawSettingsHeading_n1,
                                                ; SetModeMenuLabels
        db 050h,06Ch,061h,079h,06Fh,066h,066h,00h
str_League2:                                    ; string 'League'; used by DrawSettingsHeading_n1
        db 04Ch,065h,061h,067h,075h,065h,00h
str_ShowLeague:                                 ; string 'Show League'; used by SetModeMenuLabels
        db 053h,068h,06Fh,077h,020h,04Ch,065h,061h,067h,075h,065h,00h
str_Settings3:                                  ; string ' Settings ...'; used by SetModeMenuLabels
        db 020h,053h,065h,074h,074h,069h,06Eh,067h,073h,020h,02Eh,02Eh,02Eh,00h
lockerindex:                                    ; LockerRoomScreen: locker index of the home and the visiting
                                                ; team; used by DrawLockerJersey, DrawLockerRoom,
                                                ; LockerRoomLoop
        db 01h,00h,00h,00h,02h,00h,00h,00h,03h,00h,00h,00h,04h,00h,00h,00h
        db 06h,00h,00h,00h,07h,00h,00h,00h,09h,00h,00h,00h,0Ah,00h,00h,00h
        db 05h,00h,00h,00h,0Bh,00h,00h,00h,0Ch,00h,00h,00h,0Dh,00h,00h,00h
        db 0Eh,00h,00h,00h,0Fh,00h,00h,00h,010h,00h,00h,00h,011h,00h,00h,00h
        db 012h,00h,00h,00h,013h,00h,00h,00h,014h,00h,00h,00h,015h,00h,00h,00h
        db 016h,00h,00h,00h,017h,00h,00h,00h,018h,00h,00h,00h,019h,00h,00h,00h
        db 00h,00h,00h,00h,08h,00h,00h,00h,01Ah,00h,00h,00h,01Bh,00h,00h,00h
lockerteams:                                    ; LockerRoomScreen: team of each locker; OK sets HomeTeam /
                                                ; VisTeam from it; used by DrawLockerJersey,
                                                ; LockerRoomLoop_n0, LockerRoomLoop_n1 ...
        db 018h,00h,00h,00h,00h,00h,00h,00h,01h,00h,00h,00h,02h,00h,00h,00h
        db 03h,00h,00h,00h,08h,00h,00h,00h,04h,00h,00h,00h,05h,00h,00h,00h
        db 019h,00h,00h,00h,06h,00h,00h,00h,07h,00h,00h,00h,09h,00h,00h,00h
        db 0Ah,00h,00h,00h,0Bh,00h,00h,00h,0Ch,00h,00h,00h,0Dh,00h,00h,00h
        db 0Eh,00h,00h,00h,0Fh,00h,00h,00h,010h,00h,00h,00h,011h,00h,00h,00h
        db 012h,00h,00h,00h,013h,00h,00h,00h,014h,00h,00h,00h,015h,00h,00h,00h
        db 016h,00h,00h,00h,017h,00h,00h,00h,01Ah,00h,00h,00h,01Bh,00h,00h,00h
jerseyabbrevs:                                  ; locker room: team abbreviation for the JERSH / JERSV file
                                                ; names; used by DrawLockerJersey, DrawLockerRoom,
                                                ; LockerRoomLoop_n6
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
poroundnames:                                   ; locker room: playoff round names ('Western Conference
                                                ; Quarter' ...); used by DrawLockerJersey, DrawLockerRoom
        dd str_WesternConferenceQuarter
        dd str_EasternConferenceQuarter
        dd str_StanleyCupFinals
poroundnameidx:                                 ; locker room: index into poroundnames; used by
                                                ; DrawLockerJersey, DrawLockerRoom
        db 0FFh,0FFh,0FFh,0FFh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 01h,00h,00h,00h,02h,00h,00h,00h,02h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh
        db 01h,00h,00h,00h,02h,00h,00h,00h,02h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh
        db 01h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
lockerrects:                                    ; 16-byte rects; used by DrawLockerJersey, DrawLockerRoom,
                                                ; LockerHitTest
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
lockeracceptx:                                  ; locker room: Accept button rectangle, x; used by
                                                ; DrawLockerRoom
        db 01Bh,02h,00h,00h
lockeraccepty:                                  ; locker room: Accept button rectangle, y onward; used by
                                                ; DrawLockerRoom
        db 0B7h,01h,00h,00h,06Bh,02h,00h,00h,0CBh,01h,00h,00h
lockercancelx:                                  ; locker room: Cancel button rectangle, x; used by
                                                ; DrawLockerRoom
        db 015h,00h,00h,00h
lockercancely:                                  ; locker room: Cancel button rectangle, y onward; used by
                                                ; DrawLockerRoom
        db 0B7h,01h,00h,00h,065h,00h,00h,00h,0CBh,01h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
PcSpkSampleReady:                               ; Set to -1 once the PC speaker test sample is loaded; used by
                                                ; SetSoundDevice
        db 00h,00h,00h,00h,02Eh,053h,043h,04Eh,00h,02Eh,050h,041h,054h,00h,02Eh,054h
        db 049h,04Dh,00h,050h,043h,046h,046h,025h,030h,033h,064h,00h,050h,043h,00h
str_PCBEEP:                                     ; string 'PCBEEP'; used by SetSoundDevice
        db 050h,043h,042h,045h,045h,050h,00h,053h,042h,00h
str_SBDAC:                                      ; string 'SBDAC'; used by SetSoundDevice
        db 053h,042h,044h,041h,043h,00h,059h,04Dh,00h
str_ADLIB:                                      ; string 'ADLIB'; used by SetSoundDevice
        db 041h,044h,04Ch,049h,042h,00h,04Dh,054h,00h
str_MT322:                                      ; string 'MT32'; used by SetSoundDevice
        db 04Dh,054h,033h,032h,00h
str_SBDAC2:                                     ; string 'SBDAC'; used by SetSoundDevice
        db 053h,042h,044h,041h,043h,00h,04Eh,04Ch,00h
str_PCBEEP2:                                    ; string 'PCBEEP'; used by SetSoundDevice
        db 050h,043h,042h,045h,045h,050h,00h
str_PC:                                         ; string 'PC'; used by SetSoundDevice
        db 050h,043h,00h
soundcardrects:                                 ; 16-byte rects; used by DrawSoundCardOpts,
                                                ; RedrawSoundCardOpts, SoundCardHitTest
        db 0Eh,00h,00h,00h
        db 01Eh,00h,00h,00h
        db 071h,00h,00h,00h
        db 02Fh,00h,00h,00h,0Eh,00h,00h,00h,033h,00h,00h,00h,071h,00h,00h,00h
        db 044h,00h,00h,00h,0Eh,00h,00h,00h,048h,00h,00h,00h,071h,00h,00h,00h
        db 059h,00h,00h,00h,0Eh,00h,00h,00h,05Dh,00h,00h,00h,071h,00h,00h,00h
        db 06Eh,00h,00h,00h,0Eh,00h,00h,00h,087h,00h,00h,00h,071h,00h,00h,00h
        db 098h,00h,00h,00h,0Eh,00h,00h,00h,072h,00h,00h,00h,071h,00h,00h,00h
        db 083h,00h,00h,00h
sndselbox1:                                     ; sound card dialog: rectangle of the first selection box;
                                                ; used by SoundCardDlgLoop_poll
        db 09h,00h,00h,00h,0A4h,00h,00h,00h,03Ah,00h,00h,00h,0B4h,00h,00h,00h
sndselbox2:                                     ; sound card dialog: rectangle of the second selection box;
                                                ; used by SoundCardDlgLoop_poll
        db 045h,00h,00h,00h,0A4h,00h,00h,00h,076h,00h,00h,00h,0B4h,00h,00h,00h
SoundDevActive:                                 ; Non-zero while a sound device is set up; SetSoundDevice
                                                ; checks and clears it; used by SetSoundDevice
        db 00h,00h,00h,00h
musicdriver:                                    ; Music driver number chosen by SetSoundDevice (1 for the PC
                                                ; speaker; -1 for none); used by PlayDigiSample,
                                                ; SetSoundDevice, sfx
        db 0FFh,0FFh,0FFh,0FFh
digidriver:                                     ; SetSoundDevice: id of the second, digital sound driver (3
                                                ; Sound Blaster, 6 Ultrasound, -1 none); used by
                                                ; SetSoundDevice
        db 0FFh
        db 0FFh,0FFh,0FFh
musicslot:                                      ; music driver slot byte read before fade/wait calls
                                                ; (SndQuery(slot,3) polled until done) in PlayMVI,
                                                ; arena_logos, sound_config; used by AwardsCeremony,
                                                ; CalendarScreen, CoachCutScene ...
        db 00h
MusicOn:                                        ; music present/on flag tested before every song call (with
                                                ; songdata != 0); used by AwardsCeremony, CalendarScreen,
                                                ; ClockTick ...
        db 00h
musichandle:                                    ; music handle passed to the play (PlayDigiBlockLoop) and fade
                                                ; (SetDigiChannelVolume) calls; used by AwardsCeremony,
                                                ; CalendarScreen, DbLineEditor ...
        db 00h,00h,00h,00h
sndtempbuf:                                     ; MenuSoundSettings: the 320 KB TEMP buffer; used by
                                                ; MenuSoundSettings, SoundCardDlgLoop
        db 00h,00h,00h,00h
crowddriver:                                    ; SetSoundDevice: the digital driver the crowd noise calls use
                                                ; (Crowd_Noise, CrowdNoiseOff); used by CrowdNoiseOff,
                                                ; Crowd_Noise, SetSoundDevice
        db 00h
sounddevids:                                    ; [6] sound device ids (10h,1,4,2,8,20h) indexed by the
                                                ; NHL.CFG value; used by LoadNhlCfg, SetSoundDevice
        db 010h,00h,00h,00h,01h,00h,00h,00h,04h,00h,00h,00h,02h,00h,00h,00h
        db 08h,00h,00h,00h,020h,00h,00h,00h
str_CouldNotFindA:                              ; "Could not find a" string literal
        db 043h,06Fh,075h,06Ch,064h,020h,06Eh,06Fh,074h,020h,066h,069h,06Eh,064h,020h,061h
        db 00h
str_CardInThisMachine:                          ; "card in this machine!" string literal
        db 063h,061h,072h,064h,020h,069h,06Eh,020h,074h,068h,069h,073h,020h,06Dh,061h,063h
        db 068h,069h,06Eh,065h,021h,00h
str_SoundBlaster2:                              ; string 'SoundBlaster'; used by SetSoundDevice
        db 053h,06Fh,075h,06Eh,064h,042h,06Ch,061h,073h,074h,065h,072h,00h
str_Adlib:                                      ; string 'Adlib'; used by SetSoundDevice
        db 041h,064h,06Ch,069h,062h,00h
str_MT323:                                      ; string 'MT32'; used by SetSoundDevice
        db 04Dh,054h,033h,032h,00h
str_ULTRASOUND:                                 ; string 'ULTRASOUND'; used by SetSoundDevice
        db 055h,04Ch,054h,052h,041h,053h,04Fh,055h,04Eh,044h,00h
msg_NoSoundCard:                                ; SetSoundDevice message 'Could not find a'; used by
                                                ; SetSoundDevice
        dd str_CouldNotFindA
sndcardname:                                    ; card name string pointer
                                                ; (SoundBlaster/Adlib/MT32/ULTRASOUND); used by SetSoundDevice
        db 00h,00h,00h,00h
        dd str_CardInThisMachine
str_InitializingTheMT32Card:                    ; "Initializing the MT32 card." string literal
        db 049h,06Eh,069h,074h,069h,061h,06Ch,069h,07Ah,069h,06Eh,067h,020h,074h,068h,065h
        db 020h,04Dh,054h,033h,032h,020h,063h,061h,072h,064h,02Eh,00h
str_PleaseWait:                                 ; "Please wait." string literal
        db 050h,06Ch,065h,061h,073h,065h,020h,077h,061h,069h,074h,02Eh,00h
msg_InitMT32:                                   ; message 'Initializing the MT32 card.' / 'Please wait.'; used
                                                ; by SetSoundDevice
        dd str_InitializingTheMT32Card
        dd str_PleaseWait
        db 00h,00h,00h
str_SS5:                                        ; string '%s.%s'; used by PreloadAnnouncerClips, SayGoal,
                                                ; SayHighlightIntro ...
        db 025h,073h,02Eh,025h,073h,00h
str_PauseCor:                                   ; string 'pause.cor'; used by PreloadAnnouncerClips,
                                                ; QueueTimeClips, RequestTimeClips ...
        db 070h,061h,075h,073h,065h,02Eh,063h,06Fh,072h,00h
str_AtCor:                                      ; string 'at.cor'; used by PreloadAnnouncerClips,
                                                ; QueueTimeClips, RequestTimeClips
        db 061h,074h,02Eh,063h,06Fh,072h,00h
str_1minuteCor:                                 ; string '1minute.cor'; used by QueueTimeClips,
                                                ; RequestTimeClips
        db 031h,06Dh,069h,06Eh,075h,074h,065h,02Eh,063h,06Fh,072h,00h
str_MinutesCor:                                 ; string 'minutes.cor'; used by QueueTimeClips,
                                                ; RequestTimeClips
        db 06Dh,069h,06Eh,075h,074h,065h,073h,02Eh,063h,06Fh,072h,00h
str_1secondCor:                                 ; string '1second.cor'; used by QueueTimeClips,
                                                ; RequestTimeClips
        db 031h,073h,065h,063h,06Fh,06Eh,064h,02Eh,063h,06Fh,072h,00h
str_SecondsCor:                                 ; string 'seconds.cor'; used by QueueTimeClips,
                                                ; RequestTimeClips
        db 073h,065h,063h,06Fh,06Eh,064h,073h,02Eh,063h,06Fh,072h,00h
str_PennumCor:                                  ; string 'pennum.cor'; used by PreloadAnnouncerClips,
                                                ; SayPenalty
        db 070h,065h,06Eh,06Eh,075h,06Dh,02Eh,063h,06Fh,072h,00h
str_PensnumCor:                                 ; string 'pensnum.cor'; used by PreloadAnnouncerClips,
                                                ; SayPenalty
        db 070h,065h,06Eh,073h,06Eh,075h,06Dh,02Eh,063h,06Fh,072h,00h
str_PenshotCor:                                 ; string 'penshot.cor'; used by SayPenaltyShot
        db 070h,065h,06Eh,073h,068h,06Fh,074h,02Eh,063h,06Fh,072h,00h
str_GoalnumCor:                                 ; string 'goalnum.cor'; used by PreloadAnnouncerClips, SayGoal
        db 067h,06Fh,061h,06Ch,06Eh,075h,06Dh,02Eh,063h,06Fh,072h,00h
str_AsstnumCor:                                 ; string 'asstnum.cor'; used by PreloadAnnouncerClips, SayGoal
        db 061h,073h,073h,074h,06Eh,075h,06Dh,02Eh,063h,06Fh,072h,00h
str_AndnumCor:                                  ; string 'andnum.cor'; used by PreloadAnnouncerClips, SayGoal,
                                                ; SayPenalty
        db 061h,06Eh,064h,06Eh,075h,06Dh,02Eh,063h,06Fh,072h,00h
str_OneleftCor:                                 ; string 'oneleft.cor'; used by PreloadAnnouncerClips,
                                                ; SayGoal, SayOneMinuteLeft ...
        db 06Fh,06Eh,065h,06Ch,065h,066h,074h,02Eh,063h,06Fh,072h,00h
str_2minCor:                                    ; string '2min.cor'; used by PenaltyLenClip,
                                                ; PreloadAnnouncerClips
        db 032h,06Dh,069h,06Eh,02Eh,063h,06Fh,072h,00h
str_5minCor:                                    ; string '5min.cor'; used by PenaltyLenClip
        db 035h,06Dh,069h,06Eh,02Eh,063h,06Fh,072h,00h
str_NumberCor:                                  ; string 'number.cor'; used by SayPlayerNumber
        db 06Eh,075h,06Dh,062h,065h,072h,02Eh,063h,06Fh,072h,00h,065h,061h,073h,070h,06Fh
        db 072h,074h,073h,02Eh,069h,06Eh,074h,00h
str_NowbackInt:                                 ; string 'nowback.int'; used by FreeNowBack, SayNowBack
        db 06Eh,06Fh,077h,062h,061h,063h,06Bh,02Eh,069h,06Eh,074h,00h
str_BackmomtInt:                                ; string 'backmomt.int'; used by FreeBackMoment, SayBackMoment
        db 062h,061h,063h,06Bh,06Dh,06Fh,06Dh,074h,02Eh,069h,06Eh,074h,00h
str_CoachclpInt:                                ; string 'coachclp.int'; used by FreeCoachClip, SayCoachClip
        db 063h,06Fh,061h,063h,068h,063h,06Ch,070h,02Eh,069h,06Eh,074h,00h,06Eh,068h,06Ch
        db 02Eh,069h,06Eh,074h,00h
str_OfBar:                                      ; string 'of.bar'; used by SayHighlightIntro,
                                                ; SayPlayoffResult, SayPlayoffTonight
        db 06Fh,066h,02Eh,062h,061h,072h,00h,06Eh,075h,06Dh,062h,065h,072h,02Eh,062h,061h
        db 072h,00h,064h,069h,076h,069h,073h,069h,06Fh,06Eh,02Eh,062h,061h,072h,00h,063h
        db 06Fh,06Eh,066h,02Eh,062h,061h,072h,00h,066h,069h,06Eh,061h,06Ch,02Eh,062h,061h
        db 072h,00h,073h,065h,06Dh,069h,02Eh,062h,061h,072h,00h
str_AndBar:                                     ; string 'and.bar'; used by SayHighlightIntro,
                                                ; SayPlayoffTonight, SayTonightIntro
        db 061h,06Eh,064h,02Eh,062h,061h,072h,00h
str_BetweenBar:                                 ; string 'between.bar'; used by SayPlayoffTonight
        db 062h,065h,074h,077h,065h,065h,06Eh,02Eh,062h,061h,072h,00h
str_GamenumBar:                                 ; string 'gamenum.bar'; used by SayPlayoffResult
        db 067h,061h,06Dh,065h,06Eh,075h,06Dh,02Eh,062h,061h,072h,00h
str_EasportsBar:                                ; string 'easports.bar'; used by SayPlayoffTonight,
                                                ; SayTonightIntro
        db 065h,061h,073h,070h,06Fh,072h,074h,073h,02Eh,062h,061h,072h,00h
str_TonightBar:                                 ; string 'tonight.bar'; used by SayPlayoffTonight,
                                                ; SayTonightIntro
        db 074h,06Fh,06Eh,069h,067h,068h,074h,02Eh,062h,061h,072h,00h
str_GamebtwnBar:                                ; string 'gamebtwn.bar'; used by SayHighlightIntro,
                                                ; SayTonightIntro
        db 067h,061h,06Dh,065h,062h,074h,077h,06Eh,02Eh,062h,061h,072h,00h,070h,072h,065h
        db 073h,065h,06Eh,074h,073h,02Eh,069h,06Eh,074h,00h,068h,06Fh,063h,06Bh,065h,079h
        db 02Eh,069h,06Eh,074h,00h,069h,06Dh,072h,062h,061h,072h,072h,02Eh,069h,06Eh,074h
        db 00h
str_GoodniteInt:                                ; string 'goodnite.int'; used by SayGoodnight
        db 067h,06Fh,06Fh,064h,06Eh,069h,074h,065h,02Eh,069h,06Eh,074h,00h
str_LineupsInt:                                 ; string 'lineups.int'; used by SayLineups
        db 06Ch,069h,06Eh,065h,075h,070h,073h,02Eh,069h,06Eh,074h,00h,065h,06Ch,073h,065h
        db 077h,068h,065h,072h,02Eh,069h,06Eh,074h,00h,074h,06Fh,06Eh,069h,067h,068h,074h
        db 02Eh,069h,06Eh,074h,00h
str_TakeynowBar:                                ; string 'takeynow.bar'; used by SayHighlightIntro
        db 074h,061h,06Bh,065h,079h,06Eh,06Fh,077h,02Eh,062h,061h,072h,00h
str_HighliteBar:                                ; string 'highlite.bar'; used by SayHighlightIntro
        db 068h,069h,067h,068h,06Ch,069h,074h,065h,02Eh,062h,061h,072h,00h
str_OvertimeBar:                                ; string 'overtime.bar'; used by SayPlayoffResult
        db 06Fh,076h,065h,072h,074h,069h,06Dh,065h,02Eh,062h,061h,072h,00h
str_HavewonBar:                                 ; string 'havewon.bar'; used by SayPlayoffResult
        db 068h,061h,076h,065h,077h,06Fh,06Eh,02Eh,062h,061h,072h,00h
str_Scor1perBar:                                ; string 'scor1per.bar'; used by SayScoringPeriod_reg
        db 073h,063h,06Fh,072h,031h,070h,065h,072h,02Eh,062h,061h,072h,00h
str_Scor2perBar:                                ; string 'scor2per.bar'; used by SayScoringPeriod_reg
        db 073h,063h,06Fh,072h,032h,070h,065h,072h,02Eh,062h,061h,072h,00h
str_Scor3perBar:                                ; string 'scor3per.bar'; used by SayScoringPeriod_reg
        db 073h,063h,06Fh,072h,033h,070h,065h,072h,02Eh,062h,061h,072h,00h
str_Scor1otpBar:                                ; string 'scor1otp.bar'; used by SayScoringPeriod
        db 073h,063h,06Fh,072h,031h,06Fh,074h,070h,02Eh,062h,061h,072h,00h
str_Scor2otpBar:                                ; string 'scor2otp.bar'; used by SayScoringPeriod_ot2
        db 073h,063h,06Fh,072h,032h,06Fh,074h,070h,02Eh,062h,061h,072h,00h
str_Scor3otpBar:                                ; string 'scor3otp.bar'; used by SayScoringPeriod_ot3
        db 073h,063h,06Fh,072h,033h,06Fh,074h,070h,02Eh,062h,061h,072h,00h
str_ScortotpBar:                                ; string 'scortotp.bar'; used by SayScoringPeriod_ott
        db 073h,063h,06Fh,072h,074h,06Fh,074h,070h,02Eh,062h,061h,072h,00h
str_ThegameBar:                                 ; string 'thegame.bar'; used by SayScoringPeriod, SayTheGame
        db 074h,068h,065h,067h,061h,06Dh,065h,02Eh,062h,061h,072h,00h
penaltyclips:                                   ; 'roughing.pen' ... penalty clip names; used by
                                                ; QueuePenaltyType
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
scorperclips:                                   ; 'scor1per.bar' ... clip names; used by SayScorePeriod
        dd str_Scor1perBar
        dd str_Scor2perBar
        dd str_Scor3perBar
str_1ststarCor:                                 ; "1ststar.cor" string literal
        db 031h,073h,074h,073h,074h,061h,072h,02Eh,063h,06Fh,072h,00h
str_2ndstarCor:                                 ; "2ndstar.cor" string literal
        db 032h,06Eh,064h,073h,074h,061h,072h,02Eh,063h,06Fh,072h,00h
str_3rdstar:                                    ; Speech file name stem for the third star call
        db 033h,072h,064h,073h,074h,061h,072h,02Eh
str_Cor2:                                       ; "cor" string literal; used by SayPlayerNumber
        db 063h,06Fh,072h,00h
        dd str_1ststarCor
        dd str_2ndstarCor
        dd str_3rdstar
speechchannel:                                  ; SpeechTimerTick: sound channel of the next speech clip,
                                                ; toggled 0 / 1 per clip; used by InitSpeech, SpeechTimerTick
        db 00h,00h,00h,00h
SpeechInitMode:                                 ; Argument InitSpeech keeps; used by InitSpeech
        db 00h
speechcopylen:                                  ; copy buffer size; used by InitSpeech, MoveSampleMem
        db 00h,00h,00h,00h
speechinit:                                     ; 1 after InitSpeech, 0 after shutdown; used by InitSpeech,
                                                ; MusicChanReset, OpenAnnouncerBank ...
        db 00h,00h,00h,00h
str_VIV:                                        ; string '.VIV'; used by OpenAnnouncerBank,
                                                ; PreloadAnnouncerClips
        db 02Eh,056h,049h,056h,00h
str_SavingCurrent:                              ; "Saving Current" string literal
        db 053h,061h,076h,069h,06Eh,067h,020h,043h,075h,072h,072h,065h,06Eh,074h,00h
str_LeagueGame:                                 ; "League Game." string literal
        db 04Ch,065h,061h,067h,075h,065h,020h,047h,061h,06Dh,065h,02Eh,00h
str_PlayOffGame:                                ; "Play-Off Game." string literal
        db 050h,06Ch,061h,079h,02Dh,04Fh,066h,066h,020h,047h,061h,06Dh,065h,02Eh,00h
msg_SavingLeagueGame:                           ; 'Saving Current' / 'League Game.'; used by MenuSaveGame
        dd str_SavingCurrent
        dd str_LeagueGame
msg_SavingPlayoffGame:                          ; 'Saving Current' / 'Play-Off Game.'; used by MenuSaveGame
        dd str_SavingCurrent
        dd str_PlayOffGame
str_InsufficientDiskSpaceTo3:                   ; "Insufficient disk space to save" string literal
        db 049h,06Eh,073h,075h,066h,066h,069h,063h,069h,065h,06Eh,074h,020h,064h,069h,073h
        db 06Bh,020h,073h,070h,061h,063h,065h,020h,074h,06Fh,020h,073h,061h,076h,065h,00h
str_AGameYouRequire3:                           ; string 'a game, you require XXX Kbytes '; used by
                                                ; MenuSaveGame
        db 061h,020h,067h,061h,06Dh,065h,02Ch,020h,079h,06Fh,075h,020h,072h,065h,071h,075h
        db 069h,072h,065h,020h,058h,058h,058h,020h,04Bh,062h,079h,074h,065h,073h,020h,020h
        db 020h,00h
str_OfFreeDiskSpace2:                           ; "of free disk space." string literal
        db 06Fh,066h,020h,066h,072h,065h,065h,020h,064h,069h,073h,06Bh,020h,073h,070h,061h
        db 063h,065h,02Eh,00h
msg_NoSaveSpace:                                ; 'Insufficient disk space to save' / 'a game, you require XXX
                                                ; Kbytes' / 'of free disk space.'; used by MenuSaveGame
        dd str_InsufficientDiskSpaceTo3
        dd str_AGameYouRequire3
        dd str_OfFreeDiskSpace2
        db 00h,00h,00h
