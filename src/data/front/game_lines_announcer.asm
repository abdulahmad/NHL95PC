; The database Open dialog: current, original, and extra copies, and its buttons.
bits 32
%include "hockey.inc"
section s_C3014 progbits alloc noexec write align=1
global str_DSBOX, str_DbBut, str_None2, str_Del2, str_Open3, str_Can2, str_Noar2, str_Up2
global str_Down2, str_Arro2, str_Dbno, str_Dbcu, str_Dbtm, str_Dbor, str_Db3, str_CURRENT
global str_Org, str_ORIGINAL, str_Dbx, str_Open4, str_Delete2, str_Done2, str_Current4, str_Original2
global str_Temporary, str_Dbdialog, str_Pdbx, str_Pointer12, str_DBX2, str_Buf2, str_Pal25, str_Lineditp2
global str_Shrt2, str_Pntr3, str_Pointer13, str_Embpal4, str_Pal26, str_Lelogo, str_Menubuff8, str_C2dS2
global str_S2dSS, str_Keys3, str_Pstat3, str_Gstat3, str_SRoster, str_Pos2, str_Name2, str_G4
global str_A4, str_PT2, str_Shots4, str_PIM4, str_PlusMinus7, str_Min4, str_GAA4, str_GA3
global str_SA3, str_PCT2, str_Pal27, str_Lineditp3, str_Shrt3, str_Pntr4, str_Pointer14, str_Embpal5
global str_Pal28, str_Lelogo2, str_Menubuff9, str_C2dS3, str_Key, str_EmbS, str_HOMEPALS3, str_Bkgd10
global str_Forward, str_Line1, str_Line2, str_Line3, str_Line4, str_Power, str_Play1, str_Play2
global str_Penalty, str_Kill1, str_Kill2, str_Defense3, str_Goaltenders, str_Extra, str_Attackers, str_S2dSS2
global str_Teams2, str_ErrB2Perror, str_Tstat2, str_Keys4, str_Pstat4, str_Gstat4, str_BKGD, str_Setting5
global str_Dbox2, str_Music, str_Sound, str_DigitizedSpeech, str_Setting3, str_Pointer15, str_BKGD2, str_Setting7
global str_Setting4, str_Dbox3, str_Music2, str_Sound2, str_DigitizedSpeech2, str_Pointer16, str_BKGD3, str_DigitizedSpeech3
global str_Music3, str_Sound3, str_Setting6, str_Dbox4, str_Pointer17, str_BKGD4, str_PlayerImg, str_Dbox5
global str_OneS, str_TwoS, str_TheMouse, str_JoystickOne, str_JoystickTwo, str_TheKeyboard, str_Pointer18, str_MTROCKU
global str_SBROCKU, str_ADROCKU, str_ROCKDITI, str_Gadget6, str_Gadget5, str_Gad1, str_Pointer19, str_SaveTo
global str_HilightsReel, str_HI, str_CantOpenFile, str_HLTL, str_HLT, str_HLTS, str_Settings, str_On
global str_Off, str_Acpt, str_Canc, str_Na01, str_Na03, str_Na05, str_Pg01, str_Pg03
global str_Pg05, str_Pg07, str_Pl05, str_Pl10, str_Pl20, str_HomeBck, str_VisBck, str_HomeNameBck
global str_VisNameBck, str_TitleBck, str_Lockroom, str_P01, str_Room, str_JERSH, str_00002, str_JERSV
global str_Accept, str_Cancel2, str_HomeTeam, str_VisitingTeam, str_ExhibitionGame, str_Iff11, str_Jersey, str_Pointer20
global str_Temp8, str_Buffer, str_Sound4, str_Dbx2, str_PCSpeaker, str_SoundBlaster, str_ADLib, str_MT32
global str_UltraSound, str_Pointer21, str_Iff12, str_Maindesk2, str_Slapshot, str_MT32HOCK, str_NHL3, str_CantOpenNhlCfg
global str_04x, str_Emmcopybuf, str_Speechbuf, str_Sentence, str_SampleMemMan, str_SpeechBank, str_Cor, str_GamemiscS
global str_EastquadBar, str_EastsemdBar, str_EastfindBar, str_WestquadBar, str_WestsemdBar, str_WestfindBar, str_StanleydBar, str_EastquauBar
global str_EastsemuBar, str_EastfinuBar, str_WestquauBar, str_WestsemuBar, str_WestfinuBar, str_StanleyuBar, str_NhlInt, str_ElsenhlInt
global str_Rnk, str_Awa, str_Hom, str_Bar, str_Gamenum, str_SSS, str_Num, str_DS
global str_02dS, str_Tea, str_Pen, str_Frm, str_XBRUCE2, str_GsummaryDb4, str_AGameYouRequire, str_DemoNhl
global str_Gsummary3, str_AGameYouRequire2, str_GameSav5, str_Db4, str_Sav3, str_Pointer22, str_Savegame, str_Prmt
global str_Dialog, str_Nhl3, str_Err1, F64_BankPercent, F64_BankRate5512, F64_BankRate11025, F64_SlotPercent, F64_SlotRate11025
global str_dot2, str_S6, str_No2, str_GP8, str_C5, str_W6, str_L8, str_T6
global str_ErrA1, str_ErrA2, str_ErrA3, str_ErrA4, str_ErrA5, str_ErrA6, str_ErrA7, str_ErrA8
global str_dot3, str_S7, str_ErrB3, str_ErrB4, str_ErrB5, str_ErrB6, str_ErrB7, str_ErrB2
global str_BothTeams, str_NeitherTeams, str_K1, str_backslash4, str_F12, str_F3, str_F4, str_dot4
global str_ANA4, str_BOS2, str_BUF4, str_CGY2, str_CHI2, str_DAL2, str_DET2, str_EDM2
global str_FLA2, str_HFD2, str_LA2, str_MTL2, str_NJ2, str_NYI2, str_NYR2, str_OTT2
global str_PHI2, str_PIT2, str_QUE2, str_STL2, str_SJ2, str_TB2, str_TOR2, str_VAN2
global str_WSH2, str_WPG2, str_ASW2, str_ASE2, str_WesternConferenceQuarter, str_EasternConferenceQuarter, str_StanleyCupFinals, str_Vs
global str_R4, str_RoughingPen, str_ChargingPen, str_SlashingPen, str_XcheckPen, str_HookingPen, str_TrippingPen, str_InterferPen
global str_HoldingPen, str_AbusePen, str_CheckbndPen, str_BoardingPen, str_ElbowingPen, str_HistickPen, str_SpearingPen, str_H2
global str_h3, str_H4, str_h5, str_h6, str_h7, str_H1, str_A32, str_SDD3
str_DSBOX:                                      ; string 'DSBOX'; used by InputDialog
        db 044h,053h,042h,04Fh,058h,00h,00h,00h
str_DbBut:                                      ; string 'db_but'; used by LoadDbDialogShapes
        db 064h,062h,05Fh,062h,075h,074h,00h
str_None2:                                      ; string 'none'; used by LoadDbDialogShapes
        db 06Eh,06Fh,06Eh,065h,00h
str_Del2:                                       ; string 'del '; used by LoadDbDialogShapes
        db 064h,065h,06Ch,020h,00h
str_Open3:                                      ; string 'open'; used by LoadDbDialogShapes
        db 06Fh,070h,065h,06Eh,00h
str_Can2:                                       ; string 'can '; used by LoadDbDialogShapes
        db 063h,061h,06Eh,020h,00h
str_Noar2:                                      ; string 'noar'; used by LoadDbDialogShapes
        db 06Eh,06Fh,061h,072h,00h
str_Up2:                                        ; string 'up '; used by LoadDbDialogShapes
        db 075h,070h,020h,020h,00h
str_Down2:                                      ; string 'down'; used by LoadDbDialogShapes
        db 064h,06Fh,077h,06Eh,00h
str_Arro2:                                      ; string 'arro'; used by LoadDbDialogShapes
        db 061h,072h,072h,06Fh,00h
str_Dbno:                                       ; string 'dbno'; used by LoadDbDialogShapes
        db 064h,062h,06Eh,06Fh,00h
str_Dbcu:                                       ; string 'dbcu'; used by LoadDbDialogShapes
        db 064h,062h,063h,075h,00h
str_Dbtm:                                       ; string 'dbtm'; used by LoadDbDialogShapes
        db 064h,062h,074h,06Dh,00h
str_Dbor:                                       ; string 'dbor'; used by LoadDbDialogShapes
        db 064h,062h,06Fh,072h,00h
str_Db3:                                        ; string '*.db'; used by ScanDbFiles
        db 02Ah,02Eh,064h,062h,00h
str_CURRENT:                                    ; string 'CURRENT'; used by ScanDbFiles
        db 043h,055h,052h,052h,045h,04Eh,054h,00h
str_Org:                                        ; string '*.org'; used by ScanDbFiles
        db 02Ah,02Eh,06Fh,072h,067h,00h
str_ORIGINAL:                                   ; string 'ORIGINAL'; used by ScanDbFiles
        db 04Fh,052h,049h,047h,049h,04Eh,041h,04Ch,00h
str_Dbx:                                        ; string '*.dbx'; used by ScanDbFiles
        db 02Ah,02Eh,064h,062h,078h,00h
str_Open4:                                      ; string 'Open'; used by DrawDbDialogButtons
        db 04Fh,070h,065h,06Eh,00h
str_Delete2:                                    ; string 'Delete'; used by DrawDbDialogButtons
        db 044h,065h,06Ch,065h,074h,065h,00h
str_Done2:                                      ; string 'Done'; used by DrawDbDialogButtons
        db 044h,06Fh,06Eh,065h,00h
str_Current4:                                   ; string 'Current'; used by DrawDbDialogButtons,
                                                ; OpenSelectedDb
        db 043h,075h,072h,072h,065h,06Eh,074h,00h
str_Original2:                                  ; string 'Original'; used by DrawDbDialogButtons,
                                                ; OpenSelectedDb
        db 04Fh,072h,069h,067h,069h,06Eh,061h,06Ch,00h
str_Temporary:                                  ; string 'Temporary'; used by DrawDbDialogButtons
        db 054h,065h,06Dh,070h,06Fh,072h,061h,072h,079h,00h
str_Dbdialog:                                   ; string 'dbdialog'; used by DrawDbDialog
        db 064h,062h,064h,069h,061h,06Ch,06Fh,067h,00h
str_Pdbx:                                       ; string 'pdbx'; used by DrawDbDialog
        db 070h,064h,062h,078h,00h
str_Pointer12:                                  ; string 'Pointer'; used by DbDialogLoop
        db 050h,06Fh,069h,06Eh,074h,065h,072h,00h
str_DBX2:                                       ; string '.DBX'; used by DeleteSelectedDb, OpenSelectedDb
        db 02Eh,044h,042h,058h,00h
str_Buf2:                                       ; string 'buf'; used by MenuOpenDatabase
        db 062h,075h,066h,00h
str_Pal25:                                      ; string 'Pal'; used by DbLineEditor, DbLineEditorLoop
        db 050h,061h,06Ch,00h
str_Lineditp2:                                  ; string 'lineditp'; used by DbLineEditor
        db 06Ch,069h,06Eh,065h,064h,069h,074h,070h,00h
str_Shrt2:                                      ; string 'shrt'; used by DbLineEditor
        db 073h,068h,072h,074h,00h
str_Pntr3:                                      ; string 'pntr'; used by DbLineEditorLoop
        db 070h,06Eh,074h,072h,00h
str_Pointer13:                                  ; string 'Pointer'; used by DbLineEditorLoop
        db 050h,06Fh,069h,06Eh,074h,065h,072h,00h
str_Embpal4:                                    ; string 'embpal'; used by DbLineEditorLoop
        db 065h,06Dh,062h,070h,061h,06Ch,00h
str_Pal26:                                      ; string '!pal'; used by DbLineEditorLoop
        db 021h,070h,061h,06Ch,00h
str_Lelogo:                                     ; string 'lelogo'; used by DbLineEditorLoop
        db 06Ch,065h,06Ch,06Fh,067h,06Fh,00h
str_Menubuff8:                                  ; string 'menubuff'; used by DbLineEditorLoop
        db 06Dh,065h,06Eh,075h,062h,075h,066h,066h,00h
str_C2dS2:                                      ; string '%c %2d %s'; used by DbLineEditorLoop,
                                                ; DrawLineJerseys, DressPlayer ...
        db 025h,063h,020h,025h,032h,064h,020h,025h,073h,00h
str_S2dSS:                                      ; string '%s %2d %s%s'; used by CheckRosterComplete
        db 025h,073h,020h,025h,032h,064h,020h,025h,073h,025h,073h,00h
str_dot2:                                       ; string '.'; used by CheckRosterComplete
        db 02Eh,00h
str_S6:                                         ; string 's.'; used by CheckRosterComplete
        db 073h,02Eh,00h
str_Keys3:                                      ; string 'keys'; used by MenuShowPlayerStats
        db 06Bh,065h,079h,073h,00h
str_Pstat3:                                     ; string 'pstat'; used by MenuShowPlayerStats
        db 070h,073h,074h,061h,074h,00h
str_Gstat3:                                     ; string 'gstat'; used by MenuShowPlayerStats
        db 067h,073h,074h,061h,074h,00h,00h
str_SRoster:                                    ; string '%s Roster:'; used by ShowRosterStats
        db 025h,073h,020h,052h,06Fh,073h,074h,065h,072h,03Ah,00h
str_Pos2:                                       ; string 'Pos'; used by ShowRosterStats
        db 050h,06Fh,073h,00h
str_No2:                                        ; string 'No'; used by ShowRosterStats
        db 04Eh,06Fh,00h
str_Name2:                                      ; string 'Name'; used by ShowRosterStats
        db 04Eh,061h,06Dh,065h,00h
str_GP8:                                        ; string 'GP'; used by ShowRosterStats
        db 047h,050h,00h
str_G4:                                         ; string ' G'; used by ShowRosterStats
        db 020h,020h,047h,00h
str_A4:                                         ; string ' A'; used by ShowRosterStats
        db 020h,020h,041h,00h
str_PT2:                                        ; string ' PT'; used by ShowRosterStats
        db 020h,050h,054h,00h
str_Shots4:                                     ; string 'Shots'; used by ShowRosterStats
        db 053h,068h,06Fh,074h,073h,00h
str_PIM4:                                       ; string 'PIM'; used by ShowRosterStats
        db 050h,049h,04Dh,00h
str_PlusMinus7:                                 ; string ' +/-' (ShowRosterStats column head); used by
                                                ; ShowRosterStats
        db 020h,02Bh,02Fh,02Dh,00h
str_C5:                                         ; string '%c'; used by ShowRosterStats
        db 025h,063h,00h
str_Min4:                                       ; string ' Min'; used by ShowRosterStats
        db 020h,04Dh,069h,06Eh,00h
str_GAA4:                                       ; string ' GAA'; used by ShowRosterStats
        db 020h,020h,047h,041h,041h,00h
str_W6:                                         ; string ' W'; used by ShowRosterStats
        db 020h,057h,00h
str_L8:                                         ; string ' L'; used by ShowRosterStats
        db 020h,04Ch,00h
str_T6:                                         ; string ' T'; used by ShowRosterStats
        db 020h,054h,00h
str_GA3:                                        ; string ' GA'; used by ShowRosterStats
        db 020h,047h,041h,00h
str_SA3:                                        ; string ' SA'; used by ShowRosterStats
        db 020h,020h,053h,041h,00h
str_PCT2:                                       ; string ' PCT'; used by ShowRosterStats
        db 020h,020h,050h,043h,054h,00h,00h
str_Pal27:                                      ; string 'Pal'; used by GameLineEditor, GameLineEditorLoop
        db 050h,061h,06Ch,00h
str_Lineditp3:                                  ; string 'lineditp'; used by GameLineEditor
        db 06Ch,069h,06Eh,065h,064h,069h,074h,070h,00h
str_Shrt3:                                      ; string 'shrt'; used by GameLineEditor
        db 073h,068h,072h,074h,00h
str_Pntr4:                                      ; string 'pntr'; used by GameLineEditorLoop
        db 070h,06Eh,074h,072h,00h
str_Pointer14:                                  ; string 'Pointer'; used by GameLineEditorLoop
        db 050h,06Fh,069h,06Eh,074h,065h,072h,00h
str_Embpal5:                                    ; string 'embpal'; used by GameLineEditorLoop
        db 065h,06Dh,062h,070h,061h,06Ch,00h
str_Pal28:                                      ; string '!pal'; used by GameLineEditorLoop
        db 021h,070h,061h,06Ch,00h
str_Lelogo2:                                    ; string 'lelogo'; used by DrawLineEditorScreen,
                                                ; GameLineEditorLoop
        db 06Ch,065h,06Ch,06Fh,067h,06Fh,00h
str_Menubuff9:                                  ; string 'menubuff'; used by GameLineEditorLoop
        db 06Dh,065h,06Eh,075h,062h,075h,066h,066h,00h
str_C2dS3:                                      ; string '%c %2d %s'; used by DrawGameLineJerseys_join,
                                                ; GameDressPlayer, GameLineEditorLoop ...
        db 025h,063h,020h,025h,032h,064h,020h,025h,073h,00h
str_Key:                                        ; string 'key'; used by LoadGameRoster
        db 06Bh,065h,079h,00h
str_ErrA1:                                      ; FatalError code; used by LoadGameRoster
        db 041h,031h,00h
str_ErrA2:                                      ; FatalError code; used by LoadGameRoster
        db 041h,032h,00h
str_ErrA3:                                      ; FatalError code; used by LoadGameRoster
        db 041h,033h,00h
str_ErrA4:                                      ; FatalError code; used by LoadGameRoster
        db 041h,034h,00h
str_ErrA5:                                      ; FatalError code; used by LoadGameRoster
        db 041h,035h,00h
str_ErrA6:                                      ; FatalError code; used by LoadGameRoster
        db 041h,036h,00h
str_ErrA7:                                      ; FatalError code; used by LoadGameRoster
        db 041h,037h,00h
str_ErrA8:                                      ; FatalError code; used by LoadGameRoster
        db 041h,038h,00h
str_EmbS:                                       ; string 'emb%s'; used by DrawLineEditorScreen
        db 065h,06Dh,062h,025h,073h,00h
str_HOMEPALS3:                                  ; string 'HOMEPALS'; used by DrawLineEditorScreen,
                                                ; LoadJerseyColours
        db 048h,04Fh,04Dh,045h,050h,041h,04Ch,053h,00h
str_Bkgd10:                                     ; string 'bkgd'; used by DrawLineEditorScreen
        db 062h,06Bh,067h,064h,00h
str_Forward:                                    ; string 'forward'; used by DrawLineEditorScreen
        db 066h,06Fh,072h,077h,061h,072h,064h,00h
str_Line1:                                      ; string 'line 1'; used by DrawLineEditorScreen
        db 06Ch,069h,06Eh,065h,020h,031h,00h
str_Line2:                                      ; string 'line 2'; used by DrawLineEditorScreen
        db 06Ch,069h,06Eh,065h,020h,032h,00h
str_Line3:                                      ; string 'line 3'; used by DrawLineEditorScreen
        db 06Ch,069h,06Eh,065h,020h,033h,00h
str_Line4:                                      ; string 'line 4'; used by DrawLineEditorScreen
        db 06Ch,069h,06Eh,065h,020h,034h,00h
str_Power:                                      ; string 'power'; used by DrawLineEditorScreen
        db 070h,06Fh,077h,065h,072h,00h
str_Play1:                                      ; string 'play 1'; used by DrawLineEditorScreen
        db 070h,06Ch,061h,079h,020h,031h,00h
str_Play2:                                      ; string 'play 2'; used by DrawLineEditorScreen
        db 070h,06Ch,061h,079h,020h,032h,00h
str_Penalty:                                    ; string 'penalty'; used by DrawLineEditorScreen
        db 070h,065h,06Eh,061h,06Ch,074h,079h,00h
str_Kill1:                                      ; string 'kill 1'; used by DrawLineEditorScreen
        db 06Bh,069h,06Ch,06Ch,020h,031h,00h
str_Kill2:                                      ; string 'kill 2'; used by DrawLineEditorScreen
        db 06Bh,069h,06Ch,06Ch,020h,032h,00h
str_Defense3:                                   ; string 'defense'; used by DrawLineEditorScreen
        db 064h,065h,066h,065h,06Eh,073h,065h,00h
str_Goaltenders:                                ; string 'goaltenders'; used by DrawLineEditorScreen
        db 067h,06Fh,061h,06Ch,074h,065h,06Eh,064h,065h,072h,073h,00h
str_Extra:                                      ; string 'extra'; used by DrawLineEditorScreen
        db 065h,078h,074h,072h,061h,00h
str_Attackers:                                  ; string 'attackers'; used by DrawLineEditorScreen
        db 061h,074h,074h,061h,063h,06Bh,065h,072h,073h,00h
str_S2dSS2:                                     ; string '%s %2d %s%s'; used by CheckGameRosterComplete
        db 025h,073h,020h,025h,032h,064h,020h,025h,073h,025h,073h,00h
str_dot3:                                       ; string '.'; used by CheckGameRosterComplete
        db 02Eh,00h
str_S7:                                         ; string 's.'; used by CheckGameRosterComplete
        db 073h,02Eh,00h
str_Teams2:                                     ; string 'teams'; used by MenuSaveDefaultLines,
                                                ; MenuSaveTheseLines, MenuSaveTheseLines_x
        db 074h,065h,061h,06Dh,073h,00h
str_ErrB2Perror:                                ; "b2:" perror prefix; used by MenuSaveDefaultLines
        db 062h,032h,03Ah,00h
str_ErrB3:                                      ; FatalError code; used by MenuSaveDefaultLines,
                                                ; MenuSaveTheseLines_x
        db 042h,033h,00h
str_ErrB4:                                      ; FatalError code; used by MenuSaveDefaultLines,
                                                ; MenuSaveTheseLines_x
        db 042h,034h,00h
str_ErrB5:                                      ; FatalError code; used by MenuSaveDefaultLines,
                                                ; MenuSaveTheseLines_x
        db 042h,035h,00h
str_ErrB6:                                      ; FatalError code; used by MenuSaveDefaultLines,
                                                ; MenuSaveTheseLines_x
        db 042h,036h,00h
str_ErrB7:                                      ; FatalError code; used by MenuSaveDefaultLines,
                                                ; MenuSaveTheseLines_x
        db 042h,037h,00h
str_ErrB2:                                      ; FatalError code; used by MenuSaveTheseLines_x
        db 042h,032h,00h
str_Tstat2:                                     ; string 'tstat'; used by MenuGameShowPlayerStats
        db 074h,073h,074h,061h,074h,00h
str_Keys4:                                      ; string 'keys'; used by MenuGameShowPlayerStats
        db 06Bh,065h,079h,073h,00h
str_Pstat4:                                     ; string 'pstat'; used by MenuGameShowPlayerStats
        db 070h,073h,074h,061h,074h,00h
str_Gstat4:                                     ; string 'gstat'; used by MenuGameShowPlayerStats
        db 067h,073h,074h,061h,074h,00h,00h
str_BKGD:                                       ; string 'BKGD'; used by EditPlayoffSettings,
                                                ; LeagueSettingsDlg, MenuLeagueSettingsEdit ...
        db 042h,04Bh,047h,044h,00h
str_Setting5:                                   ; string 'setting5'; used by DrawLeagueSetDlgSel,
                                                ; MenuShowLeagueSettings2
        db 073h,065h,074h,074h,069h,06Eh,067h,035h,00h
str_Dbox2:                                      ; string 'dbox'; used by DrawLeagueSetDlg,
                                                ; DrawLeagueSetDlgSel, MenuShowLeagueSettings2
        db 064h,062h,06Fh,078h,00h
str_Music:                                      ; string 'Music'; used by DrawLeagueSetDlg,
                                                ; DrawLeagueSetDlgSel, MenuShowLeagueSettings2
        db 04Dh,075h,073h,069h,063h,00h
str_Sound:                                      ; string 'Sound'; used by DrawLeagueSetDlg,
                                                ; DrawLeagueSetDlgSel, MenuShowLeagueSettings2
        db 053h,06Fh,075h,06Eh,064h,00h
str_DigitizedSpeech:                            ; string 'Digitized Speech'; used by DrawLeagueSetDlg,
                                                ; DrawLeagueSetDlgSel, MenuShowLeagueSettings2
        db 044h,069h,067h,069h,074h,069h,07Ah,065h,064h,020h,053h,070h,065h,065h,063h,068h
        db 00h
str_Setting3:                                   ; string 'setting3'; used by DrawLeagueSetDlg,
                                                ; DrawLeagueSetDlgSel
        db 073h,065h,074h,074h,069h,06Eh,067h,033h,00h
str_Pointer15:                                  ; string 'Pointer'; used by LeagueSetEditLoop,
                                                ; LeagueSetViewLoop
        db 050h,06Fh,069h,06Eh,074h,065h,072h,00h,00h,00h,00h
str_BKGD2:                                      ; string 'BKGD'; used by MenuModeSettings
        db 042h,04Bh,047h,044h,00h
str_Setting7:                                   ; string 'setting7'; used by DrawModeSetDlg
        db 073h,065h,074h,074h,069h,06Eh,067h,037h,00h
str_Setting4:                                   ; string 'setting4'; used by DrawModeSetDlg
        db 073h,065h,074h,074h,069h,06Eh,067h,034h,00h
str_Dbox3:                                      ; string 'dbox'; used by DrawModeSetDlg
        db 064h,062h,06Fh,078h,00h
str_Music2:                                     ; string 'Music'; used by DrawModeSetDlg, ModeOptsToBits
        db 04Dh,075h,073h,069h,063h,00h
str_Sound2:                                     ; string 'Sound'; used by DrawModeSetDlg, ModeOptsToBits
        db 053h,06Fh,075h,06Eh,064h,00h
str_DigitizedSpeech2:                           ; string 'Digitized Speech'; used by DrawModeSetDlg,
                                                ; ModeOptsToBits
        db 044h,069h,067h,069h,074h,069h,07Ah,065h,064h,020h,053h,070h,065h,065h,063h,068h
        db 00h
str_Pointer16:                                  ; string 'Pointer'; used by ModeSetEditLoop, ModeSetViewLoop
        db 050h,06Fh,069h,06Eh,074h,065h,072h,00h,00h,00h,00h
str_BKGD3:                                      ; string 'BKGD'; used by MenuExhibitionSettings
        db 042h,04Bh,047h,044h,00h
str_DigitizedSpeech3:                           ; string 'Digitized Speech'; used by DrawExhSetDlg,
                                                ; ExhOptsToBits
        db 044h,069h,067h,069h,074h,069h,07Ah,065h,064h,020h,053h,070h,065h,065h,063h,068h
        db 00h
str_Music3:                                     ; string 'Music'; used by DrawExhSetDlg, ExhOptsToBits
        db 04Dh,075h,073h,069h,063h,00h
str_Sound3:                                     ; string 'Sound'; used by DrawExhSetDlg, ExhOptsToBits
        db 053h,06Fh,075h,06Eh,064h,00h
str_Setting6:                                   ; string 'setting6'; used by DrawExhSetDlg
        db 073h,065h,074h,074h,069h,06Eh,067h,036h,00h
str_Dbox4:                                      ; string 'dbox'; used by DrawExhSetDlg
        db 064h,062h,06Fh,078h,00h
str_Pointer17:                                  ; string 'Pointer'; used by ExhSetEditLoop
        db 050h,06Fh,069h,06Eh,074h,065h,072h,00h
str_BKGD4:                                      ; string 'BKGD'; used by ControlsDlgExh, ControlsDlgInGame,
                                                ; ControlsDlgLeague ...
        db 042h,04Bh,047h,044h,00h
str_PlayerImg:                                  ; string 'player'; used by DrawControlsDlg
        db 070h,06Ch,061h,079h,065h,072h,00h
str_Dbox5:                                      ; string 'dbox'; used by DrawControlsDlg
        db 064h,062h,06Fh,078h,00h
str_OneS:                                       ; string "One's"; used by DrawControlsOpts
        db 04Fh,06Eh,065h,027h,073h,00h
str_TwoS:                                       ; string "Two's"; used by DrawControlsOpts
        db 054h,077h,06Fh,027h,073h,00h
str_TheMouse:                                   ; string 'The Mouse'; used by DrawControlsOpts
        db 054h,068h,065h,020h,04Dh,06Fh,075h,073h,065h,00h
str_JoystickOne:                                ; string 'Joystick One'; used by DrawControlsOpts
        db 04Ah,06Fh,079h,073h,074h,069h,063h,06Bh,020h,04Fh,06Eh,065h,00h
str_JoystickTwo:                                ; string 'Joystick Two'; used by DrawControlsOpts
        db 04Ah,06Fh,079h,073h,074h,069h,063h,06Bh,020h,054h,077h,06Fh,00h
str_TheKeyboard:                                ; string 'The Keyboard'; used by DrawControlsOpts
        db 054h,068h,065h,020h,04Bh,065h,079h,062h,06Fh,061h,072h,064h,00h
str_Pointer18:                                  ; string 'Pointer'; used by ControlsDlgLoop
        db 050h,06Fh,069h,06Eh,074h,065h,072h,00h,00h,00h
str_MTROCKU:                                    ; string 'MTROCKU'; used by LoadRockMusic
        db 04Dh,054h,052h,04Fh,043h,04Bh,055h,00h
str_SBROCKU:                                    ; string 'SBROCKU'; used by LoadRockMusic
        db 053h,042h,052h,04Fh,043h,04Bh,055h,00h
str_ADROCKU:                                    ; string 'ADROCKU'; used by LoadRockMusic
        db 041h,044h,052h,04Fh,043h,04Bh,055h,00h
str_ROCKDITI:                                   ; string 'ROCKDITI'; used by LoadRockMusic
        db 052h,04Fh,043h,04Bh,044h,049h,054h,049h,00h,00h,00h,00h
str_BothTeams:                                  ; string 'Both Teams'; used by bothneitherstrs
        db 042h,06Fh,074h,068h,020h,054h,065h,061h,06Dh,073h,00h
str_NeitherTeams:                               ; string 'Neither Teams'; used by bothneitherstrs
        db 04Eh,065h,069h,074h,068h,065h,072h,020h,054h,065h,061h,06Dh,073h,00h
str_Gadget6:                                    ; string 'gadget6'; used by InstantReplay, ReplaySaveHilight,
                                                ; ReplaySaveHilight_n3
        db 067h,061h,064h,067h,065h,074h,036h,00h
str_Gadget5:                                    ; string 'gadget5'; used by InstantReplay
        db 067h,061h,064h,067h,065h,074h,035h,00h
str_Gad1:                                       ; string 'gad1'; used by InstantReplay, ReplaySaveHilight,
                                                ; ReplaySaveHilight_n3
        db 067h,061h,064h,031h,00h
str_Pointer19:                                  ; string 'Pointer'; used by ReplaySaveHilight
        db 050h,06Fh,069h,06Eh,074h,065h,072h,00h
str_SaveTo:                                     ; string 'Save To'; used by HilightSaveToDlg
        db 053h,061h,076h,065h,020h,054h,06Fh,00h
str_HilightsReel:                               ; string 'Hilights Reel'; used by HilightSaveToDlg
        db 048h,069h,06Ch,069h,067h,068h,074h,073h,020h,052h,065h,065h,06Ch,00h
str_K1:                                         ; string 'k1'; used by SaveHilight
        db 06Bh,031h,00h
str_backslash4:                                 ; string backslash; used by SaveHilight
        db 05Ch,00h
str_HI:                                         ; string '.HI'; used by SaveHilight
        db 02Eh,048h,049h,00h
str_F12:                                        ; string 'f1'; used by SaveHilight
        db 066h,031h,00h
str_CantOpenFile:                               ; string "Can not open `%s' file\n"; used by SaveHilight
        db 043h,061h,06Eh,020h,06Eh,06Fh,074h,020h,06Fh,070h,065h,06Eh,020h,060h,025h,073h
        db 027h,020h,066h,069h,06Ch,065h,0Ah,00h
str_F3:                                         ; string 'f3'; used by SaveHilight
        db 066h,033h,00h
str_F4:                                         ; string 'f4'; used by SaveHilight
        db 066h,034h,00h,00h,00h
str_dot4:                                       ; string '.' (TeamFromHiName separator); used by
                                                ; TeamFromHiName
        db 02Eh,00h
str_HLTL:                                       ; string 'HLTL'; used by SelectHilight
        db 048h,04Ch,054h,04Ch,00h
str_HLT:                                        ; string 'HLT'; used by SelectHilight
        db 048h,04Ch,054h,00h
str_HLTS:                                       ; string 'HLTS'; used by SelectHilight
        db 048h,04Ch,054h,053h,00h
str_Settings:                                   ; string 'settings'; used by LoadSettingsShapes
        db 073h,065h,074h,074h,069h,06Eh,067h,073h,00h
str_On:                                         ; string 'On '; used by LoadSettingsShapes
        db 04Fh,06Eh,020h,020h,00h
str_Off:                                        ; string 'Off '; used by LoadSettingsShapes
        db 04Fh,066h,066h,020h,00h
str_Acpt:                                       ; string 'acpt'; used by LoadSettingsShapes
        db 061h,063h,070h,074h,00h
str_Canc:                                       ; string 'canc'; used by LoadSettingsShapes
        db 063h,061h,06Eh,063h,00h
str_Na01:                                       ; string 'na01'; used by LoadSettingsShapes
        db 06Eh,061h,030h,031h,00h
str_Na03:                                       ; string 'na03'; used by LoadSettingsShapes
        db 06Eh,061h,030h,033h,00h
str_Na05:                                       ; string 'na05'; used by LoadSettingsShapes
        db 06Eh,061h,030h,035h,00h
str_Pg01:                                       ; string 'pg01'; used by LoadSettingsShapes
        db 070h,067h,030h,031h,00h
str_Pg03:                                       ; string 'pg03'; used by LoadSettingsShapes
        db 070h,067h,030h,033h,00h
str_Pg05:                                       ; string 'pg05'; used by LoadSettingsShapes
        db 070h,067h,030h,035h,00h
str_Pg07:                                       ; string 'pg07'; used by LoadSettingsShapes
        db 070h,067h,030h,037h,00h
str_Pl05:                                       ; string 'pl05'; used by LoadSettingsShapes
        db 070h,06Ch,030h,035h,00h
str_Pl10:                                       ; string 'pl10'; used by LoadSettingsShapes
        db 070h,06Ch,031h,030h,00h
str_Pl20:                                       ; string 'pl20'; used by LoadSettingsShapes
        db 070h,06Ch,032h,030h,00h,00h
str_ANA4:                                       ; "ANA" string literal
        db 041h,04Eh,041h,00h
str_BOS2:                                       ; "BOS" string literal
        db 042h,04Fh,053h,00h
str_BUF4:                                       ; "BUF" string literal
        db 042h,055h,046h,00h
str_CGY2:                                       ; "CGY" string literal
        db 043h,047h,059h,00h
str_CHI2:                                       ; "CHI" string literal
        db 043h,048h,049h,00h
str_DAL2:                                       ; "DAL" string literal
        db 044h,041h,04Ch,00h
str_DET2:                                       ; "DET" string literal
        db 044h,045h,054h,00h
str_EDM2:                                       ; "EDM" string literal
        db 045h,044h,04Dh,00h
str_FLA2:                                       ; "FLA" string literal
        db 046h,04Ch,041h,00h
str_HFD2:                                       ; "HFD" string literal
        db 048h,046h,044h,00h
str_LA2:                                        ; "LA" string literal
        db 04Ch,041h,00h
str_MTL2:                                       ; "MTL" string literal
        db 04Dh,054h,04Ch,00h
str_NJ2:                                        ; "NJ" string literal
        db 04Eh,04Ah,00h
str_NYI2:                                       ; "NYI" string literal
        db 04Eh,059h,049h,00h
str_NYR2:                                       ; "NYR" string literal
        db 04Eh,059h,052h,00h
str_OTT2:                                       ; "OTT" string literal
        db 04Fh,054h,054h,00h
str_PHI2:                                       ; "PHI" string literal
        db 050h,048h,049h,00h
str_PIT2:                                       ; "PIT" string literal
        db 050h,049h,054h,00h
str_QUE2:                                       ; "QUE" string literal
        db 051h,055h,045h,00h
str_STL2:                                       ; "STL" string literal
        db 053h,054h,04Ch,00h
str_SJ2:                                        ; "SJ" string literal
        db 053h,04Ah,00h
str_TB2:                                        ; "TB" string literal
        db 054h,042h,00h
str_TOR2:                                       ; "TOR" string literal
        db 054h,04Fh,052h,00h
str_VAN2:                                       ; "VAN" string literal
        db 056h,041h,04Eh,00h
str_WSH2:                                       ; "WSH" string literal
        db 057h,053h,048h,00h
str_WPG2:                                       ; "WPG" string literal
        db 057h,050h,047h,00h
str_ASW2:                                       ; "ASW" string literal
        db 041h,053h,057h,00h
str_ASE2:                                       ; "ASE" string literal
        db 041h,053h,045h,00h
str_WesternConferenceQuarter:                   ; "Western Conference Quarter-Finals" string literal
        db 057h,065h,073h,074h,065h,072h,06Eh,020h,043h,06Fh,06Eh,066h,065h,072h,065h,06Eh
        db 063h,065h,020h,051h,075h,061h,072h,074h,065h,072h,02Dh,046h,069h,06Eh,061h,06Ch
        db 073h,00h
str_EasternConferenceQuarter:                   ; "Eastern Conference Quarter-Finals" string literal
        db 045h,061h,073h,074h,065h,072h,06Eh,020h,043h,06Fh,06Eh,066h,065h,072h,065h,06Eh
        db 063h,065h,020h,051h,075h,061h,072h,074h,065h,072h,02Dh,046h,069h,06Eh,061h,06Ch
        db 073h,00h
str_StanleyCupFinals:                           ; string 'Stanley Cup Finals'
        db 053h,074h,061h,06Eh,06Ch,065h,079h,020h,043h,075h,070h,06h,020h,046h,069h,06Eh
        db 061h,06Ch,073h,00h
str_HomeBck:                                    ; string 'HomeBck'; used by LockerRoomScreen
        db 048h,06Fh,06Dh,065h,042h,063h,06Bh,00h
str_VisBck:                                     ; string 'VisBck'; used by LockerRoomScreen
        db 056h,069h,073h,042h,063h,06Bh,00h
str_HomeNameBck:                                ; string 'HomeNameBck'; used by LockerRoomScreen
        db 048h,06Fh,06Dh,065h,04Eh,061h,06Dh,065h,042h,063h,06Bh,00h
str_VisNameBck:                                 ; string 'VisNameBck'; used by LockerRoomScreen
        db 056h,069h,073h,04Eh,061h,06Dh,065h,042h,063h,06Bh,00h
str_TitleBck:                                   ; string 'TitleBck'; used by LockerRoomScreen
        db 054h,069h,074h,06Ch,065h,042h,063h,06Bh,00h
str_Lockroom:                                   ; string 'lockroom'; used by DrawLockerRoom
        db 06Ch,06Fh,063h,06Bh,072h,06Fh,06Fh,06Dh,00h
str_P01:                                        ; string '!p01'; used by DrawLockerJersey, DrawLockerRoom
        db 021h,070h,030h,031h,00h
str_Room:                                       ; string 'room'; used by DrawLockerRoom
        db 072h,06Fh,06Fh,06Dh,00h
str_JERSH:                                      ; string 'JER%sH'; used by DrawLockerJersey, DrawLockerRoom
        db 04Ah,045h,052h,025h,073h,048h,00h
str_00002:                                      ; string '0000'; used by DrawLockerJersey, DrawLockerRoom
        db 030h,030h,030h,030h,00h
str_JERSV:                                      ; string 'JER%sV'; used by DrawLockerJersey, DrawLockerRoom
        db 04Ah,045h,052h,025h,073h,056h,00h
str_Vs:                                         ; string 'vs'; used by DrawLockerRoom
        db 076h,073h,00h
str_Accept:                                     ; string 'Accept'; used by DrawLockerRoom
        db 041h,063h,063h,065h,070h,074h,00h
str_Cancel2:                                    ; string 'Cancel'; used by DrawLockerRoom
        db 043h,061h,06Eh,063h,065h,06Ch,00h
str_HomeTeam:                                   ; string 'Home Team'; used by DrawLockerRoom
        db 048h,06Fh,06Dh,065h,020h,054h,065h,061h,06Dh,00h
str_VisitingTeam:                               ; string 'Visiting Team'; used by DrawLockerRoom
        db 056h,069h,073h,069h,074h,069h,06Eh,067h,020h,054h,065h,061h,06Dh,00h
str_ExhibitionGame:                             ; string 'Exhibition Game'; used by DrawLockerRoom
        db 045h,078h,068h,069h,062h,069h,074h,069h,06Fh,06Eh,020h,047h,061h,06Dh,065h,00h
str_Iff11:                                      ; string '.iff'; used by DrawLockerRoom
        db 02Eh,069h,066h,066h,00h
str_Jersey:                                     ; string 'jersey'; used by DrawLockerRoom
        db 06Ah,065h,072h,073h,065h,079h,00h
str_Pointer20:                                  ; string 'Pointer'; used by LockerRoomLoop
        db 050h,06Fh,069h,06Eh,074h,065h,072h,00h,00h,00h
str_Temp8:                                      ; string 'temp'; used by MenuSoundSettings
        db 074h,065h,06Dh,070h,00h
str_Buffer:                                     ; string 'buffer'; used by MenuSoundSettings
        db 062h,075h,066h,066h,065h,072h,00h
str_Sound4:                                     ; string 'sound'; used by DrawSoundCardDlg
        db 073h,06Fh,075h,06Eh,064h,00h
str_Dbx2:                                       ; string 'dbx2'; used by DrawSoundCardDlg
        db 064h,062h,078h,032h,00h
str_PCSpeaker:                                  ; string 'PC Speaker'; used by DrawSoundCardOpts,
                                                ; RedrawSoundCardOpts
        db 050h,043h,020h,053h,070h,065h,061h,06Bh,065h,072h,00h
str_SoundBlaster:                               ; string 'Sound Blaster'; used by DrawSoundCardOpts,
                                                ; RedrawSoundCardOpts
        db 053h,06Fh,075h,06Eh,064h,020h,042h,06Ch,061h,073h,074h,065h,072h,00h
str_ADLib:                                      ; string 'AD Lib'; used by DrawSoundCardOpts,
                                                ; RedrawSoundCardOpts
        db 041h,044h,020h,04Ch,069h,062h,00h
str_MT32:                                       ; string 'MT-32'; used by DrawSoundCardOpts,
                                                ; RedrawSoundCardOpts
        db 04Dh,054h,02Dh,033h,032h,00h
str_UltraSound:                                 ; string 'UltraSound'; used by DrawSoundCardOpts,
                                                ; RedrawSoundCardOpts
        db 055h,06Ch,074h,072h,061h,053h,06Fh,075h,06Eh,064h,00h
str_Pointer21:                                  ; string 'Pointer'; used by SoundCardDlgLoop
        db 050h,06Fh,069h,06Eh,074h,065h,072h,00h
str_Iff12:                                      ; string '.iff'; used by SoundCardDlgLoop_poll
        db 02Eh,069h,066h,066h,00h
str_Maindesk2:                                  ; string 'maindesk'; used by SoundCardDlgLoop_poll
        db 06Dh,061h,069h,06Eh,064h,065h,073h,06Bh,00h
str_Slapshot:                                   ; string 'slapshot'; used by SetSoundDevice
        db 073h,06Ch,061h,070h,073h,068h,06Fh,074h,00h
str_MT32HOCK:                                   ; string 'MT32HOCK'; used by SetSoundDevice
        db 04Dh,054h,033h,032h,048h,04Fh,043h,04Bh,00h
str_NHL3:                                       ; string 'NHL'; used by SetSoundDevice
        db 04Eh,048h,04Ch,00h
str_R4:                                         ; string 'r+'; used by SetSoundDevice
        db 072h,02Bh,00h
str_CantOpenNhlCfg:                             ; string 'cannot open nhl.cfg'; used by SetSoundDevice
        db 063h,061h,06Eh,06Eh,06Fh,074h,020h,06Fh,070h,065h,06Eh,020h,06Eh,068h,06Ch,02Eh
        db 063h,066h,067h,00h
str_04x:                                        ; string '%04x '; used by SetSoundDevice
        db 025h,030h,034h,078h,0Ah,00h
str_Emmcopybuf:                                 ; string 'emmcopybuf'; used by SetSoundDevice
        db 065h,06Dh,06Dh,063h,06Fh,070h,079h,062h,075h,066h,00h
str_RoughingPen:                                ; "roughing.pen" string literal
        db 072h,06Fh,075h,067h,068h,069h,06Eh,067h,02Eh,070h,065h,06Eh,00h
str_ChargingPen:                                ; "charging.pen" string literal
        db 063h,068h,061h,072h,067h,069h,06Eh,067h,02Eh,070h,065h,06Eh,00h
str_SlashingPen:                                ; "slashing.pen" string literal
        db 073h,06Ch,061h,073h,068h,069h,06Eh,067h,02Eh,070h,065h,06Eh,00h
str_XcheckPen:                                  ; "xcheck.pen" string literal
        db 078h,063h,068h,065h,063h,06Bh,02Eh,070h,065h,06Eh,00h
str_HookingPen:                                 ; "hooking.pen" string literal
        db 068h,06Fh,06Fh,06Bh,069h,06Eh,067h,02Eh,070h,065h,06Eh,00h
str_TrippingPen:                                ; "tripping.pen" string literal
        db 074h,072h,069h,070h,070h,069h,06Eh,067h,02Eh,070h,065h,06Eh,00h
str_InterferPen:                                ; "interfer.pen" string literal
        db 069h,06Eh,074h,065h,072h,066h,065h,072h,02Eh,070h,065h,06Eh,00h
str_HoldingPen:                                 ; "holding.pen" string literal
        db 068h,06Fh,06Ch,064h,069h,06Eh,067h,02Eh,070h,065h,06Eh,00h
str_AbusePen:                                   ; "abuse.pen" string literal
        db 061h,062h,075h,073h,065h,02Eh,070h,065h,06Eh,00h
str_CheckbndPen:                                ; "checkbnd.pen" string literal
        db 063h,068h,065h,063h,06Bh,062h,06Eh,064h,02Eh,070h,065h,06Eh,00h
str_BoardingPen:                                ; "boarding.pen" string literal
        db 062h,06Fh,061h,072h,064h,069h,06Eh,067h,02Eh,070h,065h,06Eh,00h
str_ElbowingPen:                                ; "elbowing.pen" string literal
        db 065h,06Ch,062h,06Fh,077h,069h,06Eh,067h,02Eh,070h,065h,06Eh,00h
str_HistickPen:                                 ; "histick.pen" string literal
        db 068h,069h,073h,074h,069h,063h,06Bh,02Eh,070h,065h,06Eh,00h
str_SpearingPen:                                ; "spearing.pen" string literal
        db 073h,070h,065h,061h,072h,069h,06Eh,067h,02Eh,070h,065h,06Eh,00h
str_Speechbuf:                                  ; string 'speechbuf'; used by InitSpeechSlots
        db 073h,070h,065h,065h,063h,068h,062h,075h,066h,00h
str_Sentence:                                   ; string 'sentence'; used by InitSpeech
        db 073h,065h,06Eh,074h,065h,06Eh,063h,065h,00h
str_SampleMemMan:                               ; string 'sample mem man'; used by InitSpeech
        db 073h,061h,06Dh,070h,06Ch,065h,020h,06Dh,065h,06Dh,020h,06Dh,061h,06Eh,00h
str_SpeechBank:                                 ; string 'speech bank'; used by InitSpeech
        db 073h,070h,065h,065h,063h,068h,020h,062h,061h,06Eh,06Bh,00h
F64_BankPercent:                                ; Double 100.0 used by OpenSpeechBank
        db 00h,00h,00h,00h,00h,00h,059h,040h
F64_BankRate5512:                               ; Double 5512.0 used by OpenSpeechBank
        db 00h,00h,00h,00h,00h,088h,0B5h,040h
F64_BankRate11025:                              ; used by OpenSpeechBank
        db 00h,00h,00h,00h,080h,088h,0C5h,040h
F64_SlotPercent:                                ; Double 100.0 used by LoadSpeechSlot
        db 00h,00h,00h,00h,00h,00h,059h,040h
F64_SlotRate11025:                              ; used by LoadSpeechSlot
        db 00h,00h,00h,00h,080h,088h,0C5h,040h
str_Cor:                                        ; string 'cor'; used by PenaltyLenClip
        db 063h,06Fh,072h,00h
str_GamemiscS:                                  ; string 'gamemisc.%s'; used by PenaltyLenClip
        db 067h,061h,06Dh,065h,06Dh,069h,073h,063h,02Eh,025h,073h,00h
str_EastquadBar:                                ; string 'eastquad.bar'; used by PlayoffRoundClipD
        db 065h,061h,073h,074h,071h,075h,061h,064h,02Eh,062h,061h,072h,00h
str_EastsemdBar:                                ; string 'eastsemd.bar'; used by PlayoffRoundClipD
        db 065h,061h,073h,074h,073h,065h,06Dh,064h,02Eh,062h,061h,072h,00h
str_EastfindBar:                                ; string 'eastfind.bar'; used by PlayoffRoundClipD
        db 065h,061h,073h,074h,066h,069h,06Eh,064h,02Eh,062h,061h,072h,00h
str_WestquadBar:                                ; string 'westquad.bar'; used by PlayoffRoundClipD
        db 077h,065h,073h,074h,071h,075h,061h,064h,02Eh,062h,061h,072h,00h
str_WestsemdBar:                                ; string 'westsemd.bar'; used by PlayoffRoundClipD
        db 077h,065h,073h,074h,073h,065h,06Dh,064h,02Eh,062h,061h,072h,00h
str_WestfindBar:                                ; string 'westfind.bar'; used by PlayoffRoundClipD
        db 077h,065h,073h,074h,066h,069h,06Eh,064h,02Eh,062h,061h,072h,00h
str_StanleydBar:                                ; string 'stanleyd.bar'; used by PlayoffRoundClipD
        db 073h,074h,061h,06Eh,06Ch,065h,079h,064h,02Eh,062h,061h,072h,00h
str_EastquauBar:                                ; string 'eastquau.bar'; used by PlayoffRoundClipU
        db 065h,061h,073h,074h,071h,075h,061h,075h,02Eh,062h,061h,072h,00h
str_EastsemuBar:                                ; string 'eastsemu.bar'; used by PlayoffRoundClipU
        db 065h,061h,073h,074h,073h,065h,06Dh,075h,02Eh,062h,061h,072h,00h
str_EastfinuBar:                                ; string 'eastfinu.bar'; used by PlayoffRoundClipU
        db 065h,061h,073h,074h,066h,069h,06Eh,075h,02Eh,062h,061h,072h,00h
str_WestquauBar:                                ; string 'westquau.bar'; used by PlayoffRoundClipU
        db 077h,065h,073h,074h,071h,075h,061h,075h,02Eh,062h,061h,072h,00h
str_WestsemuBar:                                ; string 'westsemu.bar'; used by PlayoffRoundClipU
        db 077h,065h,073h,074h,073h,065h,06Dh,075h,02Eh,062h,061h,072h,00h
str_WestfinuBar:                                ; string 'westfinu.bar'; used by PlayoffRoundClipU
        db 077h,065h,073h,074h,066h,069h,06Eh,075h,02Eh,062h,061h,072h,00h
str_StanleyuBar:                                ; string 'stanleyu.bar'; used by PlayoffRoundClipU
        db 073h,074h,061h,06Eh,06Ch,065h,079h,075h,02Eh,062h,061h,072h,00h
str_NhlInt:                                     ; string 'nhl.int'; used by SayNhlIntro
        db 06Eh,068h,06Ch,02Eh,069h,06Eh,074h,00h
str_ElsenhlInt:                                 ; string 'elsenhl.int'; used by SayElseNhl
        db 065h,06Ch,073h,065h,06Eh,068h,06Ch,02Eh,069h,06Eh,074h,00h
str_Rnk:                                        ; string 'rnk'; used by SayHighlightIntro, SayPlayoffTonight,
                                                ; SayTonightIntro
        db 072h,06Eh,06Bh,00h
str_Awa:                                        ; string 'awa'; used by SayHighlightIntro, SayPlayoffResult,
                                                ; SayPlayoffTonight ...
        db 061h,077h,061h,00h
str_Hom:                                        ; string 'hom'; used by SayHighlightIntro, SayPlayoffTonight,
                                                ; SayTonightIntro
        db 068h,06Fh,06Dh,00h
str_Bar:                                        ; string 'bar'; used by SayPlayoffResult, SayPlayoffTonight
        db 062h,061h,072h,00h
str_Gamenum:                                    ; string 'gamenum'; used by SayPlayoffResult,
                                                ; SayPlayoffTonight
        db 067h,061h,06Dh,065h,06Eh,075h,06Dh,00h
str_SSS:                                        ; string '%s%s.%s'; used by SayPlayoffResult,
                                                ; SayPlayoffTonight
        db 025h,073h,025h,073h,02Eh,025h,073h,00h
str_Num:                                        ; string 'num'; used by QueuePenaltyType, QueueTimeClips,
                                                ; RequestTimeClips ...
        db 06Eh,075h,06Dh,00h
str_DS:                                         ; string '%d.%s'; used by QueuePenaltyType, QueueTimeClips,
                                                ; RequestTimeClips ...
        db 025h,064h,02Eh,025h,073h,00h
str_02dS:                                       ; string '%02d.%s'; used by QueuePenaltyType, QueueTimeClips,
                                                ; RequestTimeClips
        db 025h,030h,032h,064h,02Eh,025h,073h,00h
str_Tea:                                        ; string 'tea'; used by PreloadAnnouncerClips, SayGoal,
                                                ; SayPenalty ...
        db 074h,065h,061h,00h
str_Pen:                                        ; string 'pen'; used by SayPenalty
        db 070h,065h,06Eh,00h
str_Frm:                                        ; string 'frm'; used by SayPlayerNumber
        db 066h,072h,06Dh,00h
str_XBRUCE2:                                    ; string 'XBRUCE2'; used by OpenAnnouncerBank,
                                                ; PreloadAnnouncerClips
        db 058h,042h,052h,055h,043h,045h,032h,00h
str_GsummaryDb4:                                ; string 'gsummary.db'; used by MenuSaveGame
        db 067h,073h,075h,06Dh,06Dh,061h,072h,079h,02Eh,064h,062h,00h
str_AGameYouRequire:                            ; string 'a game, you require %3d Kbytes'; used by
                                                ; MenuSaveGame
        db 061h,020h,067h,061h,06Dh,065h,02Ch,020h,079h,06Fh,075h,020h,072h,065h,071h,075h
        db 069h,072h,065h,020h,025h,033h,064h,020h,04Bh,062h,079h,074h,065h,073h,00h
str_DemoNhl:                                    ; string 'demo.nhl'; used by MenuSaveGame
        db 064h,065h,06Dh,06Fh,02Eh,06Eh,068h,06Ch,00h
str_H2:                                         ; string 'h2'; used by MenuSaveGame
        db 068h,032h,00h
str_h3:                                         ; string 'h3': MenuSaveGame fatal error tag; used by
                                                ; MenuSaveGame
        db 068h,033h,00h
str_Gsummary3:                                  ; string 'gsummary'; used by MenuSaveGame
        db 067h,073h,075h,06Dh,06Dh,061h,072h,079h,00h
str_H4:                                         ; string 'h4'; used by MenuSaveGame
        db 068h,034h,00h
str_h5:                                         ; string 'h5': MenuSaveGame fatal error tag; used by
                                                ; MenuSaveGame
        db 068h,035h,00h
str_h6:                                         ; string 'h6': MenuSaveGame fatal error tag; used by
                                                ; MenuSaveGame
        db 068h,036h,00h
str_h7:                                         ; string 'h7': MenuSaveGame fatal error tag; used by
                                                ; MenuSaveGame
        db 068h,037h,00h
str_AGameYouRequire2:                           ; string 'a game, you require %3d Kbytes'; used by
                                                ; MenuSaveGame
        db 061h,020h,067h,061h,06Dh,065h,02Ch,020h,079h,06Fh,075h,020h,072h,065h,071h,075h
        db 069h,072h,065h,020h,025h,033h,064h,020h,04Bh,062h,079h,074h,065h,073h,00h
str_GameSav5:                                   ; string 'game.sav'; used by MenuSaveGame
        db 067h,061h,06Dh,065h,02Eh,073h,061h,076h,00h
str_H1:                                         ; string 'h1'; used by MenuSaveGame
        db 068h,031h,00h
str_Db4:                                        ; string '.db'; used by MenuSaveGame
        db 02Eh,064h,062h,00h
str_Sav3:                                       ; string '.sav'; used by MenuSaveGame
        db 02Eh,073h,061h,076h,00h
str_A32:                                        ; string 'A3'; used by MenuSaveGame
        db 041h,033h,00h
str_Pointer22:                                  ; string 'pointer'; used by SaveGameNameDlg
        db 070h,06Fh,069h,06Eh,074h,065h,072h,00h
str_Savegame:                                   ; string 'savegame'; used by SaveGameNameDlg
        db 073h,061h,076h,065h,067h,061h,06Dh,065h,00h
str_Prmt:                                       ; string 'prmt'; used by SaveGameNameDlg
        db 070h,072h,06Dh,074h,00h
str_Dialog:                                     ; string 'dialog'; used by SaveGameNameDlg
        db 064h,069h,061h,06Ch,06Fh,067h,00h
str_Nhl3:                                       ; string '.nhl'; used by SaveGameNameDlg
        db 02Eh,06Eh,068h,06Ch,00h
str_Err1:                                       ; string 'err1'; used by SaveGameNameDlg
        db 065h,072h,072h,031h,00h,00h,00h,00h
str_SDD3:                                       ; string '%s %d - %d'
        db 025h,073h,020h,025h,064h,020h,02Dh,020h,025h,064h,00h
