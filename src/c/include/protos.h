/* protos.h - prototypes of the functions written in C (every matched function goes here) and of asm functions
   whose register signature is known. Watcom register convention (-5r): arguments in eax, edx, ebx, ecx, then the
   stack; result in eax. Keep the asm label as the name. */
#ifndef PROTOS_H
#define PROTOS_H
struct Player; struct Team;

/* 001_10010_main_startup */
void assreplace(struct Player *p, int ass);                /* 11FF4: replace p's current assignment (94G checks94 assreplace) */

/* 037_4842A_engine_player_logic */
void StopIfFree(struct Player *p);                        /* 4A80E */
void pucknorm(struct Player *p);                          /* 4D8C7 */
void assexit(struct Player *p);                           /* 4D509 */
void pucknothing(struct Player *p);                       /* 4D8FD */
void puckunflip(struct Player *p);                        /* 4D907 */
/* 038_4FCE8_engine_input */
void joyq_flush(void);                                    /* 4FD47 */
unsigned char *joyq_peek(void);                           /* 4FD62 */
/* 040_53294_engine_physics_ai */
void Sweepcheck(struct Player *p);                        /* 532A2 */
int ToFixed(int v);                                       /* 53294 */
void setpassmode(struct Player *p);                       /* 551AF */
/* 041_59493_engine_sound_iface */
void WaitDigiSample(void);                                /* 599EE */
int PaSpeechBusy(void);                                   /* 59AAD */
void PaPlayerNumber(char *team, int phrase, int number);  /* 59B0F */
void PaOpenBank(void);                                    /* 59D54 */
void CrowdNoiseReset(void);                               /* 59863 */
/* 042_59D9A_engine_core */
void changeplayer(struct Player *p, short cont);              /* 59E69 */
short restorepl(short newpl, short oldpl);                /* 59FE1 */
void AvgCline(struct Team *t);                            /* 5A03B */
void calcpuckcross(void);                                 /* 5A341 */
void GetHot(struct Player *p);                             /* 5A425 */
void Setplass(struct Player *p);                          /* 5B298 */
void Acheck(struct Player *p, struct Player *q);           /* 4FFAE */
void SetLCmode(struct Player *p);                         /* 4D9FC */
void assdopen(struct Player *p);                          /* 4AFFB */
int TryAddPlayerToList(struct Team *t, short pl, short slot); /* 5BB9E */
void defaultsprites2(void);                                 /* 5BA89 */
void ResetBench(void);                                     /* 5DF86 */
void setpersonel(struct Team *t);                          /* 5BEF4 */
void StartPer(void);                                       /* 5C010 */
void SetupTeamForIntermission(void);                       /* 5DDDA */
void GiveControl(short pl);                                /* 5B1CE */
void setupice(void);                                       /* 5D7F7 */
void updatecrowdf(void);                                    /* 5C248 */
int AllInPlace(void);                                      /* 51440 */
void ForceStartLineup(short team);                          /* 5125F */
void StartFaceoffLineChange(struct Player *r, struct Player *p); /* 4DA37 */
void PassCompleted(struct Player *p);                     /* 50AFE */
short Findhittype(struct Player *p, short dir);            /* 579FF */
void puckflip(struct Player *p);                          /* 4DFA4 */
void puckbody(Player *pk, Player *p);                    /* 56D06 */
void assbenchwait(struct Player *p);                       /* 526ED */
void NextPathPoint(void);                                   /* 4F99B */
short check4bench(struct Player *p);                       /* 52BB6: nonzero when the player is at the bench (assbenchwait test ax,ax) */
void reenergizeteam(struct Team *t);                      /* 5B826 */
void RestBench(void);                                     /* 5C1E2 */
void restoreteams(void);                                  /* 5B97A */
int PenTeamScored(void);                                  /* 5AAAE */
void Intermission(void);                                  /* 5DE42 */
void StartGame(void);                                     /* 5E086 */
void forceteams(void);                                    /* 5E0B0 */
void forcepldata(struct Team *t);                         /* 5E0DD */
void SetSPA(struct Player *p, short spa);                 /* 59D9A */
short GetPeriodTime(void);                                /* 5B9D1 */
void ClearSortCords(void);                                /* 5BA4E */
void LockScroll(void);                                    /* 5CD25 */
void GameOver(void);                                      /* 5DD9E */
void SetExitGame(void);                                   /* 5DDBC */
/* 043_5E16D_engine_skating */
void doplayeracc(struct Player *p, short dir);             /* 5E16D */
void skateto(struct Player *p, void (*evade)(struct Player *p)); /* 5E93B */
void avdgoal(struct Player *p);                           /* 5F151 */
void playeracc(struct Player *p, short dir);               /* 5EDAD */
void goalieacc(struct Player *p, short dir);               /* 5F8B2 */
void EvadePlayers(struct Player *p);                      /* 5E4C4 */
void dostop(struct Player *p);                            /* 5F745 */
void StopNA(struct Player *p);                            /* 5F82A (asm) */
/* 045_614C2_scoring_penalty_text */
void updatePPTeamTime(void);                              /* 63B57 */
void ClearPenaltyBuffer(void);                            /* 63D3C */
/* 046_644A8_engine_display */
unsigned char *ReplayFirstFrame(void);                    /* 67581 */
unsigned char *ReplayPrevFrame(void);                     /* 675A0 */
void CloseTextOverlay(void);                              /* 66DDA */
void ReplayRecordReset(void);                             /* 67564 */
/* asm functions with a known signature */
short vtoa(int dx, int dy);                               /* hand-written: direction 0-7 of the vector (dx, dy) */
int SpeechBusy(void);                                     /* announcer sample still playing? */
short randomd0(short range);                              /* random 0..range-1 (93G randomd0) */
int OpenAnnouncerBank(void);                              /* 0 = failed */
short sub_8F80E(int handle);                              /* sound library: sample finished? */
int ReplayIsEmpty(void);                                   /* 12034 */
void TextGridFree(void);                                  /* 17756 */
int FileClose(int *h);                                    /* 1457C */
short GameTimeStamp(void);                                /* 62CD7 */
void _nfree(void *p);                                     /* Watcom CRT _nfree_ */
int _dos_close(int h);                                    /* Watcom CRT _dos_close_ */
int DateKey(int month, int day);  /* 41C79 */             
unsigned Swap16(unsigned x);  /* 837D9 */                 
int RandMod(int n);
int rand(void);  /* Watcom CRT rand_ */                   
void SimAddPair(int *count, int *pairs, int a, int b);  /* 452A6 */
int StrLenToDot(char *s);  /* 1D5D5 */                    
unsigned char *TeamRecPtr(int team);  /* 6CB90 */         
unsigned char *CarTeamRecPtr(int team);  /* 6CB6B */      
unsigned char *KeyDbPtr(int ofs);  /* 6CBB7 */            
double RatingToFloat(unsigned char r);  /* 6F6AD */       
int GetMemListHead(int which);  /* 10010 */               
int SpeechIsInit(void);  /* 836CA */                      
void MusicChanCmd3(void);
void sub_8FCAC(int handle, int cmd);  /* sound library */ 
void CalReturn(void);  /* 3476B */                        
int DeskToSportsDesk(void);  /* 1A5B1 */                  
int FileCreate(char *name, int *h);
int _dos_creat(char *name, int attr, int *h);  /* Watcom CRT _dos_creat_ */
void CenterMouse(void);
void __cdecl MouseSetPos(int x, int y);  /* input library, stack args */
void WriteKeyRec(int fh, void *rec, long pos);  /* 14654 */
int FileWriteAt(int fh, void *buf, long pos, unsigned len);  /* 145F9 */
int FileReadAt(int fh, void *buf, long pos, unsigned len);  /* 145A2: seek to pos (pos < 0: no seek), read len bytes */
void ReadSchedGame(int fh, void *game, int n);  /* 147A0 */
void TextGridOff(void);  /* 1777E */                      
void SetTextColors(int color, int shadow);  /* 174C2 */   
void SaveModeState(unsigned char *st);
char *strcpy(char *d, const char *s);  /* Watcom CRT strcpy_ */
int DeskSetExit1(void);  /* 179B6 */                      
void SndLoadFile(int unused, char *name);
void *__cdecl sub_8E8B8(char *name, int bank);  /* sound library loader, stack args */
void NudgeRinkScroll(void);  /* 7FC12 */                  
void ClampYPosition(Player *p);  /* 4B6F4 */              
void CrowdFadeOut(void);
void __cdecl sub_B3989(int n);  /* timer library, stack args */
void __cdecl sub_B3999(void);  /* timer library */        
void PaPreloadClips(int a, int b);
void TextGridPut(int x, int y, char *s);
void *memcpy(void *d, const void *s, unsigned n);  /* Watcom CRT memcpy_ */
unsigned strlen(const char *s);  /* Watcom CRT strlen_ */ 
void POSetSeriesTeams(unsigned char *s, int a, int b);  /* 87520 */
void GoalieToPuckVec(Player *p);  /* 4B467 */             
void TryBlockShot(Player *p);
int CanBlockShot(Player *p);  /* 4FFEE */                 
void BlockShotDive(Player *p, int how);  /* 53387 */      
void NullBlit(void);  /* 1D019 */                         
void NullFunc_1D024(void);  /* 1D024 */                   
void DemoSetupStub(void);  /* 3371C */                    
void rtss(void);  /* 4F990 */                             
void CreatePlayerNop(void);  /* 6FA72 */                  
void SettingsStub(void);  /* 7B39C */                     
void stub_8C1B7(void);  /* 8C1B7 */                       
void stub_8C1F7(void);  /* 8C1F7 */                       
void stub_8C202(void);  /* 8C202 */                       
void stub_8C20D(void);  /* 8C20D */                       
void stub_8C218(void);  /* 8C218 */                       
int DlgReturnZero(void);  /* 2FED2 */                     
int GadgetStub0(void);  /* 7E032 */                       
int LeagueCheckStub(void);  /* 41337 */                   
int POReturnZero(void);  /* 89B5C */                      
int DeskBackToGame(void);  /* 1A5A1 */                    
int MenuExit(void);  /* 3270B */                          
int MenuReturnToLineEditor(void);  /* 79DD1 */            
int MenuPlayNextGame(void);  /* 86627 */                  
int MenuReturnToSportsCentral(void);  /* 86637 */         
void TeamSelCancel(void);  /* 38B3A */                    
void TeamSelDone(void);  /* 38B25 */                      
void TradeCancel(void);  /* 3EF27 */                      
void EditRostersReturn(void);  /* 6D5BB */                
void SetLeagueSetImage(int img);  /* 7A6AD */             
int CritErrHandler(void);  /* 3149D */                    
void assreplace(Player *p, int a);  /* 11FF4 */           
void assinsert(Player *p, short a);  /* 12011 */          
void ReadLeagueTeamEntry(int fh, void *entry, int n);  /* 3A31E */
int StrPrefixDiffers(char *a, char *b);  /* 1D6BE */      
void DrawRinkEndArt(void);
void DrawSprite(int spr, int x, int y, int a, int b, int c);  /* 1CD73 */
void SetBoxDoorObject(int open);
void SetRinkObject(int obj, int frame);  /* 614C2 */      
int SpeechSlotLoaded(int i);  /* 83F35 */                 
int SpeechSlotSize(int i);  /* 83BC7 */                   
int ReadBE32(signed char *p);  /* 16072 */                
void PaPenaltyShot(char *team, int num, int min, int sec);
int SayPenaltyShot(char *team, int num, int min, int sec);  /* 8511E */                  
int SpeechIdle(void);  /* 83711 */                        
void WaitKeyRelease(int key);
int __cdecl sub_B2CBE(int key);  /* keyboard library: key down? */
void __cdecl sub_B3A24(void);  /* keyboard library */     
unsigned char RandLfsrByte(unsigned char *s);  /* 7665E */
void puckunflip(Player *p);  /* 4D907 */                  
void CopyRoster1Rec(void);  /* 6DE4C */                   
void GetLineEnergies(short team, int *out);  /* 14BEF */  
short TeamLineEnergy(short team, short line);  /* 5A2EE */
void DrawButtons(Button *b, int n);  /* 30AE2 */          
void DrawButton(Button *b);  /* 30B16 */                  
void PaHighlightIntro(int home, int vis);  /* 59CA9 */    
void SetListItemColors(int sel, int item);  /* 30209 */   
void __cdecl sub_8E9C0(int fg, int bg);  /* graphics library: set text colours */
void PlayDigiSample(void *s);  /* 599B9 */                
void StopDigiSample(void);  /* 59981 */                   
int sub_8F270(void *s, int a);  /* sound library: start sample */
void ClearSpeechSlot(unsigned char *s);  /* 833C5 */      
void WriteTeamRec(int fh, void *rec, int n);  /* 3A2B8 */ 
int FileExists(char *name);  /* 142E7 */                  
int FileOpenRead(char *name, int *h);  /* 14525: 0 = ok */
void FreeCalendarIfLowMem(void);  /* 212C6 */             
int __cdecl sub_8DAB8(void);  /* memory library: free memory */
void __cdecl jctime(int p);  /* library: free a block */  
void StopDigiSample(void);  /* 59981 */                   
void sub_8F67D(int h);  /* sound library: stop sample */  
void FreeDigiSample(int unused);  /* 59945 */             
void sub_8F7AE(int h);  /* sound library: free sample */  
int ClearInputQueue(void);  /* 6B3D7 */                   
int ResetInputSampling(void);  /* 1145F */                
void NormalizeDressFlags(void);  /* 65B48 */              
void CheckAndReleasePlayer(Team *t, short i);  /* 639F9 */
void sfx(int n);  /* 59884 */                             
void ReadCString(char *s, int fh);  /* 8385F */           
unsigned _dos_read(int fh, void __far *buf, unsigned n, unsigned *got);  /* Watcom CRT _dos_read_ */
void FlushGSumQueue(void);  /* 61B85 */                   
void AppendGSumRecord(unsigned char *rec);  /* 61A8A */   
int CountSelected(char *list);  /* 6DA88 */               
int StrEqNoCase(char *a, char *b);  /* 83E32 */           
void InputRemove(void);  /* 6B47C */                      
void __cdecl sub_8E4F8(void (*f)(void));  /* timer library: remove a tick handler */
void InputPollTick(void);  /* input tick handler */       
int FindFreeSpeechSlot(int i);  /* 83E6D */               
int FindLoadedSpeechSlot(int i);  /* 83EAC */             
void SpeechStopQueue(void);  /* 8374D */                  
void DrawCtlBoxes(void);  /* 7D671 */                     
void DrawCtlBoxOn(int *r);  /* 7C852 */                   
void DrawCtlBoxOff(int *r);  /* 7C901 */                  
void TextGridOpen(void);  /* 17711 */                     
void *_nmalloc(unsigned n);  /* Watcom CRT _nmalloc_ */   
void *memset(void *d, int c, unsigned n);  /* Watcom CRT memset_ */
unsigned char *GetInputEvent(void);  /* 6B391 */          
int TeamFromHiName(char *s);  /* 7FC5C */                 
unsigned strcspn(const char *s, const char *set);  /* Watcom CRT strcspn_ */
int stricmp(const char *a, const char *b);  /* Watcom CRT stricmp_ */
void SetPA(short pa);  /* 62EA2 */                        
void MakePath(char *out, char *dir, char *name, char *ext);  /* 1431E */
char *strcat(char *d, const char *s);  /* Watcom CRT strcat_ */
void InitScrollBar(int *sb, int visible, int total);  /* 30BF3 */
int FindSpeechSlot(char *name);  /* 83EEB */              
void MakeGSummaryPath(void);  /* 1C807 */                 
void RestoreGridCellBg(int unused1, int unused2);  /* 37E5B */                
void __cdecl sub_903F0(int buf, int x, int y);  /* graphics library: put a saved block */
void RestoreDialogBg(void);  /* 30F12 */                  
void PenaltyLenClip(int len, char *out);  /* 842BA */     
int sprintf(char *d, const char *fmt, ...);  /* Watcom CRT sprintf_ */
void GetHotOrStick(Player *p);  /* 5A534 */               
void GetHotStick(Player *p);  /* 5A4AD */                 
int MenuLeagueHilights(void);  /* 3366F */                
void LoadModeState(void *st);  /* 327A1 */                
int ViewHilights(void);  /* 80075 */                      
int LockerHitTest(int x, int y, int *hit);  /* 81520 */   
int AddStar(short n, short team, short pl);  /* 48789 */  
void PanelRemovePenalty(short away, short pl);  /* 14CA0 */
int DbDialogHitTest(int x, int y, int *hit);  /* 72A5C */ 
int CtlDlgHitTest(int x, int y, int *hit);  /* 7D61F */   
int SoundCardHitTest(int x, int y, int *hit);  /* 827B3 */
int GadgetHitTest(int x, int y, int *hit);  /* 7E8E5 */   
void PrintShadowText(int x, int y, char *s);  /* 175E2 */ 
void __cdecl sub_91964(char *s, int x, int y);  /* graphics library: print a string */
void GrowToButton(int *b, int *w, int *h);  /* 30F5F */   
void chkatop(void);  /* 639A4 */                          
void ResetGoalieMenu(void);  /* 1CB7F */                  
void ResetSampleReq(void);  /* 83520 */                   
void CtlSwapTeamFlag(int team);  /* 7CC8A */              
void MenuP1ControlsInGame(void);  /* 7CAF7 */
int ControlsDlgInGame(int side);  /* 7CB03 */
void MenuP2ControlsInGame(void);  /* 7CB9F */
void ReassignCtlPlayer(int side);  /* 7CCE5 */
void ClearCtlBlink(void);  /* 7CEA1 */
int SayOneMinuteLeft(void);  /* 854AC */                  
void ResetSpeechQueue(void);  /* 833FA */                 
void RequestSample(char *name);  /* 83FAF */              
void EnsureSampleRoom(void);  /* 8426F */                 
void QueueSpeechClip(char *name);  /* 84418 */            
int SayScorePeriod(int per);  /* 84657 */                 
void joyq_pop(void);  /* 4FCE8 */                         
void DrawRosterPanel(int side);  /* 6D299 */              
void DrawRosterTitle(int x, int y, int side);  /* 6CEFB */
void DrawRosterList(int x, int y, int side);  /* 6CF6F */ 
void DrawDatabaseName(void);  /* 6D256 */                 
int CountShotOnGoal(void);  /* 64338 */                   
void ShotLaneOpen(void);  /* 64102 */                     
void ClearPanelPenalties(void);  /* 1CBD8 */              
void LoadScoreboardGfx(void);  /* 1CC3D */                
int AnyInputPressed(void);  /* 1600C */                   
int PollKey(void);  /* keyboard library */                
int sub_B3464(void);  /* joystick library: read both pads */
void CompShoot(Player *p);  /* 55A35 */                   
void passmode(Player *p);  /* 5514E */                    
void dopass(Player *p);  /* 54DF4 */                      
void MeasureTextLine(char *s, int *maxw, int *total, int add);  /* 309E4 */
int __cdecl fputchar(char *s);  /* text library at 90AC4 (label kept): text width in pixels, stack arg */
void NormalizeDate(unsigned char *month, unsigned char *day);  /* 41C9B */
void SwapInt(int a, int b, int *arr);  /* 42F19 */        
void MsgCopyingDatabases(int arg);  /* 414E0 */           
int MessageBox(int x, int y, char *msg, int type, int a, int b, int c, int d, int e);  /* 31013 */
char *strupr(char *s);  /* Watcom CRT strupr_ */          
void PrintCenteredText(int y, char *s);  /* 17573 */      
unsigned DiskFreeBytes(int drive);  /* 106C8 */           
unsigned _dos_getdiskfree(unsigned drive, void *d);  /* Watcom CRT _dos_getdiskfree_ */
void __cdecl FatalError(char *msg, ...);  /* B2CD8: printf-style message, then exit */
int FileOpenWrite(char *name, int *h);  /* 1453E */
int SaveHilight(int team);  /* 7FA10 */
void SetPalette768(unsigned char *pal);  /* 76614 */      
void __cdecl sub_B4C84(void);  /* video library: wait for retrace */
void __cdecl sub_B4B88(int first, int count, unsigned char *rgb);  /* video library: set palette entries */
void ShowDBError(int *sel, int *state, int msg, int arg);  /* 6ED39 */
void __cdecl sub_B4BA8(void);  /* video library */        
void __cdecl sub_9121C(int buf);  /* graphics library */  
void ErrorScreenWait(int msg, int arg, char *title, int type);  /* 6EAB5 */
void FmtFromLeague(char *dst, char *name, char *file);  /* 41171 */
unsigned _fstrcspn(const char __far *s, const char __far *set);  /* Watcom CRT _fstrcspn_ */
void POPreSimRound1(unsigned char *po, int a, int b);  /* 87F85 */
void POSimSeriesTeamWins(unsigned char *s, int team);
void POSimSeries(unsigned char *s, int games);
void POPreSimRound2(unsigned char *po, int a, int b);  /* 87FE0 */
void POPreSimConfFinals(unsigned char *po, int a, int b);  /* 8803B */
int TradeRosterCmp(unsigned char *a, unsigned char *b);  /* 3FEF0 */
int strcmp(const char *a, const char *b);  /* Watcom CRT strcmp_ */
int ComparePlayerEntry(unsigned char *a, unsigned char *b);  /* 6D78B */
int GameRosterCmp(unsigned char *a, unsigned char *b);  /* 76A93 */
void holdplayer(Player *p);  /* 503CD */         
int OppInReach(Player *p);
void SetPenaltyStrength(void);  /* 510A9 */               
void MakeSampleRoom(void);  /* 84205 */                   
void LoadTransparentRinkEndOverlay(void);  /* 13A2F */    
int __cdecl sub_8E8A0(char *path, int flags);  /* graphics library: load bank */
int __cdecl sub_B30B4(int bank, char *name);  /* graphics library: find art */
void PrintLineEdStatus(int x, int y, char *s);  /* 76771 */
void __cdecl sub_90D20(int x, int y, int w, int h, int col);  /* graphics library: fill rect */
int GetLeagueDBSizes(char *drive, int *kb, char *ext);  /* 149BF */
unsigned unknown_libname_1(const char *path, unsigned attr, void *ft);  /* Watcom CRT _dos_findfirst */
void DeskReloadGame(void);  /* 1A534 */                   
void LoadRink(int team);
void LoadPlayerPhotos(void);
void __cdecl sub_8FFB0(int first, int count, unsigned char *pal);  /* graphics library: set palette */
void FadePalStep(int dir, unsigned char *pal, int steps);
void CalNextMonth(void);  /* 34691 */                     
void CalPrevMonth(void);
void CalPrevMonth(void);  /* 346FE */                     
void getlchoice(Player *p);  /* 50908 */                  
void PrintClampedText(int x, int y, char *s);  /* 2F580 */
void EndPenaltyShot(void);  /* 64439 */                   
void AddPenalty2(struct Player *p, short pen);
void newcheck(short kind);  /* 58084 */                   
int FreeUnrequestedSamples(void);  /* 84036 */            
int IsSampleRequested(char *name);
int a2offsides(Player *p);  /* 4DCDD */                   
void AddPenalty(Player *p, short pen);
void DrawSoundCardDlg(void);  /* 8261C */                 
int __cdecl sub_8E83C(char *path, int flags);  /* graphics library: load bank */
void __cdecl sub_91284(int art, int x, int y);  /* graphics library: draw art */
void InitMenuRemap(int mode);  /* 1FAA7 */                
void __cdecl sub_B4DD4(unsigned char *remap);  /* graphics library: set colour remap */
int AskDatabaseChoice(void);  /* 2FDD1 */                 
void __cdecl sub_B2DCA(int *btn, int *y, int *x);  /* mouse library: read state */
void AskLeftRight(unsigned char *left, char *prompt);  /* 6FBE8 */
char InputDialog(int *lines, int n, char *buf, int len, int a, int b, int c, int d, int e);
void releasepl(Team *tm, short pl);  /* 6392A */          
void setplayer(Player *p, int pl);
void puckIChk(void);  /* 56E52 */                         
int DiskSpaceShort(int drive, int *kb);  /* 14825 */      
void DrawTradeRow(int side);  /* 3E7B3 */                 
int __cdecl sub_93170(int x, int y, char *fmt, ...);  /* graphics library: printf at x / y */
void puckshadow(Player *p);  /* 56ECF */                  
void SetShotMode(Player *p);  /* 5786E */                 
void FitPlayerName(char *dst, char *first, char *last, int maxw);  /* 29C75 */
int WaitLeagueFloppy(char *file, char *name, char *dir);  /* 3D84F */
int FindLeagueFloppy(char *file, char *name, char *dir);
int PlayerFromMouseY(int x, int y, int *idx);  /* 24453 */
void RemovePlayerFromTeam(unsigned char team, int key);  /* 71043 */
int TickPanelClock(int hund);  /* 15374 */                
int SkillForAnim(Player *p);  /* 54134 */                 
void ScatterPass(Player *p, Player *to);  /* 54D63 */     
void PlayoffRoundClipD(char *buf, unsigned conf, unsigned round);  /* 84306 */
void PlayoffRoundClipU(char *buf, unsigned conf, unsigned round);  /* 8438F */
void SetGameSides(int team, unsigned char *games, int g);  /* 347B7 */
void SetCtlTeams(int t1, int t2, int home, int away);
char *strncpy(char *d, const char *s, unsigned n);  /* Watcom CRT strncpy_ */
int ExhSetHitTest(int x, int y, int *hit);  /* 7C28D */   
int ModeSetHitTest(int x, int y, int *hit);  /* 7B734 */  
int MenuMergeLeagueFiles(void);  /* 33469 */              
int MergeLeagueFiles(void);
int __cdecl sub_8CCA8(char *name, int size, int flags);  /* file library: load file */
int CupSeriesWinner(unsigned char *s, unsigned games);  /* 15CE1 */
void DrawModeSetChecks(void);  /* 7B7BE */                
void SetRinkScroll(int x, int y);  /* 33DD3 */            
void sub_6A033(int what);  /* engine display: redraw */   
void IntermissionPC(void);  /* 10F6D */                   
void FadePalette(int dir, unsigned char *pal, int steps);
void SetScreenSize(int w, int h);
void MusicChanReset(void);
void sub_8F633(void);  /* sound library: stop */          
void sub_1BAF3(int ticks);
void __cdecl sub_8EA18(int font);  /* text library: set font */
void __cdecl sub_8E9E8(void *state);  /* text library: save the text state (40h bytes) */
void __cdecl sub_8EA00(void *state);  /* text library: restore the text state */
void DrawSettingsHeading(int x, int y, int n, int mode, int colour);  /* 8050F */
void IntermissionDesk(void);
void LoadScreenPalTick(void);  /* 47951 */                
void __cdecl sub_B4C61(void);  /* video library: wait for retrace */
void MoveInDir(Player *p, short dir);  /* 49260 */        
void CrowdNoiseOff(void);  /* 59748 */                    
void sub_8FDB2(int card, int voice, int vol);  /* sound library: set voice volume */
void sub_8FE4F(int card, int voice, int what);  /* sound library: voice control */
void RenderTextLine(int x, int y, char *s);  /* 174D8 */  
int __cdecl sub_B4F8C(int w, int h, int flags);  /* graphics library: create bitmap */
void __cdecl sub_B3A88(void *save);  /* graphics library: save draw state */
void __cdecl SetDrawBitmap(int bmp);
void __cdecl sub_B392C(int col);  /* graphics library: clear */
void __cdecl sub_B3AA1(void *save);  /* graphics library: restore draw state */
void __cdecl sub_91370(int art, int x, int y);  /* graphics library: draw art */
void __cdecl sub_9132C(int bmp);  /* graphics library: free bitmap */
int FacingBoards(Player *p);  /* 5378D */                 
int QueueGoalieNote(void);  /* 62C37 */                   
void QueueDeferredCall(void *fn, int a, int b, int c, int d, int e, int f, int g);
void faceoffinput(Player *p);  /* 4FF0D */                
void StartPenaltyShot(void);  /* 64398 */                 
void MakeJerseyShape(unsigned char *buf, unsigned num, unsigned char c1, unsigned char c2);  /* 7A099 */
void BlitJerseyDigit(unsigned char *dst, unsigned d, int c1, int c2, int right);
void DrawDBErrorsScreen(int *sel, int *line, int *first);  /* 6EC95 */
void DrawMenuBar(void *bar, int n, int col1, int col2, int col3);
void FadeOutPalCycle(void);  /* 47C31 */                  
int lcselect(Player *p, int n);  /* 50434 */              
void DrawPanelLine(int side, int line);
void SetDialogColors(int a, int b, int c, int d, int e);
int SelectHilight(char *name, int *idx, unsigned char *league, int a, int b);
void PlayHilight(void);
void PenShotStart(short side);  /* 511B4 */               
void SaveDialogBg(int x, int y, int w, int h);  /* 30E66 */
void __cdecl sub_91400(int buf, int x, int y);  /* graphics library: grab screen rect */
int SetupDemoGame(void);  /* 13FA7 */                     
void BuildDefaultLines(void);
void SetupTeamLines(int side);
void ResetGameVars(void);
int StartPreGame(int mode);
void assintrostand(Player *p);  /* 4842A */               
void SetRinkObject(int i, int v);  /* 614C2 */            
void RunGameFrames(int n);  /* 1149A */                   
int HandleHotKey(int key);
void ClockTick(void);
void DoGameFrame(void);
void MarkTwoLinePlayers(Player *pk);  /* 55C6F */         
int QuickShotChk(Player *p);  /* 6427F */                 
void SortNonDefPlayers(short side, signed char *out, short *keys);  /* 6455F */
void __cdecl sub_93540(int n, int *keys, int *idx);  /* sort library */
void SortPlayersByPos(short side, signed char *out, short *keys, char pos);  /* 644A8 */
void LoadCupFinalSeries(void);  /* 15B76 */               
int LoadScheduleDB(int *db);  /* 891B2 */
void InitSpeechSlots(int size);  /* 83459 */              
int __cdecl sub_8CC70(char *name, int size, int flags);  /* memory library: allocate */
int __cdecl sub_8DBD4(int buf);  /* memory library */     
void InitSpeech(unsigned char id, int size, int copybuf, int copylen);  /* 8357A */
int __cdecl sub_8E4C0(void (*fn)(void));  /* timer library: add tick handler */
void BuildSavedGameLabels(void);  /* 1D518 */             
void sfx(int id);  /* 59884 */                            
void sub_8F61D(int id);  /* sound library: play effect */ 
void assrefatdot(Player *p);  /* 4DFF7 */                 
int ChkTwoLinePass(Player *p);  /* 4DD51 */               
void SetTeamGoalie(short side, short g);  /* 672F9 */     
void DeleteTempDatabases(void);  /* 7125C */              
int j_unlink(char *path);  /* CRT unlink thunk */         
void SetSideControls(void);  /* 8B85B */                  
int StatsMenuPoints(void);  /* 18348 */                   
;int LeadersScreen(int cat);
int TeamStatsScreen(int cat);
int StatsMenuGoals(void);  /* 18425 */                    
int StatsMenuAssists(void);  /* 18508 */                  
int StatsMenuPPGoals(void);  /* 185EB */                  
int StatsMenuSHGoals(void);  /* 186CE */                  
int StatsMenuPlusMinus(void);  /* 187B1 */                
int StatsMenuPIM(void);  /* 18894 */                      
int StatsMenuShootPct(void);  /* 18977 */                 
int StatsMenuGAA(void);  /* 18A5A */                      
int StatsMenuGoalieWins(void);  /* 18B3D */               
int StatsMenuTeamScoring(void);  /* 17EDF */              
int StatsMenuTeamDefense(void);  /* 17FBC */              
int StatsMenuPenaltyKilling(void);  /* 1809F */           
int StatsMenuPowerPlay(void);  /* 18182 */                
int StatsMenuTeamPenalties(void);  /* 18265 */            
int StatsMenuStandings(void);  /* 17DFC */                
void assstanley(Player *p);  /* 4A832 */                  
void PeriodOver(void);  /* 5DEA6 */                       
void IntermissionStart(void);
int DeleteFiles(char *dir, char *name, char *ext);  /* 14368 */
unsigned unknown_libname_2(void *ft);  /* Watcom CRT _dos_findnext */
void DeleteDir(char *dir);  /* 14442 */                   
int rmdir(const char *path);  /* Watcom CRT rmdir_ */     
void AdjustFacingDirection(Player *p, int want);  /* 4B4E9 */
int OneTimerChk(Player *p);  /* 50E5C */                  
int StatsMenuSavePct(void);  /* 18C20 */                  
void StatsSel9394Season(void);  /* 17A00 */               
int CmpGoals(int *a, int *b);  /* 25144 */                
int CmpAssists(int *a, int *b);  /* 25237 */              
int CmpPlusMinus(int *a, int *b);  /* 2554B */            
int CmpPoints(int *a, int *b);  /* 1FB7F */               
int CmpPIM(int *a, int *b);  /* 25642 */                  
int CmpPPGoals(int *a, int *b);  /* 25325 */              
int CmpSHGoals(int *a, int *b);  /* 25438 */              
int CmpShootPct(int *a, int *b);  /* 25755 */             
void InitCoachModes(void);  /* 5A669 */                   
short SetCoachMode(int side);
void ChkGoalies(void);  /* 59265 */                       
void CPgoalie(Team *t, Team *o, int y);
int ChkPullGoalieLate(int side);  /* 593F5 */
int SetupGame(void);  /* 13E8F */                         
void DrawHudPanel(int home, int vis, int a, int b);
void PlacePlayersAtStart(void);
void MergeSeasonRecDelta(short *old, short *cur, short *dst, int a, int b);  /* 3A71C */
void MergeTeamRecDelta(unsigned char *old, unsigned char *cur, unsigned char *dst, int a, int b);  /* 3A5FC */
int LoadLeagueGameRef(int fh);  /* 41B80 */               
short checkagr(Player *p);  /* 5369F */                   
void assepen(Player *p);  /* 4B02D */                     
void StartShotPath(Player *p, int dist);  /* 4F9EF */     
void Bcheck(Player *a, Player *b);  /* 56A54 */           
void FallDown(Player *p, Player *by);
void periodicevents(void);  /* 5C302 */                   
void PenaltyManager(void);
void DecayCrowdLevel(void);
void clockcont_0(void);
void UpdatePowerPlayFlags(void);
void ShotMode(Player *p);  /* 578FA */                    
void asscenterd(Player *p);  /* 4A53A */                  
void assbenchside(Player *p);  /* 49BC2 */                
int CopyGameSettings(char *src, char *dst);  /* 32C9E */  
int FileOpenRW(char *name, int *h);  /* 14552: 0 = ok */  
int MenuNextLeagueGame(int *fh);  /* 33559 */             
void SetupStatsSourceMenu(int src);
void SetScreenTitle(int title);
void PlayLeagueGame(int *fh);
void SetRosterTeamMenus(int side, int team);  /* 7183D */ 
void CtlSwapScoreFix(int side);  /* 7CBB3 */              
void ModeOptsToBits(void);  /* 7B604 */                   
void ExhOptsToBits(void);  /* 7BF56 */                    
void LeagueOptsToBits(void);  /* 7A88E */                 
int CmpSavePct(int *a, int *b);  /* 259C0 */              
int CmpGoalieWins(int *a, int *b);  /* 2586A */           
void PostGameDesk(void);  /* 1920F */                     

int GameSummaryScreen(int mode, int period, int arg3, int arg4);
void PickOtherGames(int home, int vis);
void UpdateOtherScores(int period);
int PlayRandomHighlight(void);
void SportsDesk(int mode);
void ShowLoadingScreen(void);
void ReadGSumTail(void);
void ReadGSumHeader(void);
void WriteGSumHeader(void);
void InputInstall(void);
void sub_1B982(void);
int CoachCutScene(void);
int WaitClickTimeout(int secs);
void DrawExhSetChecks(void);
void DrawLeagueSetChecks(void);
void DrawDeskFrames(void);  /* 18E43 */                   
void __cdecl sub_B4FAC(int x1, int y1, int x2, int y2, int colour);
int StartHL2(int home, int vis, int *homescore, int *visscore, int period);
int SayTonightIntro(char *rnk, char *away, char *home);  /* 84B0D */
char *itoa(int v, char *buf, int radix);
int SayHighlightIntro(char *rnk, char *away, char *home);  /* 847CE */
int SayPlayoffResult(char *team, int game, unsigned conf, unsigned round, int ot, int final);  /* 8490D */
void DrawSoundCardOpts(void);  /* 82690 */                
void DrawSelBoxOn(Rect4 *r);
void DrawSelBoxOff(Rect4 *r);
void RedrawSoundCardOpts(void);  /* 82805 */              
void ClearPlayerFromLines(unsigned char p, unsigned char *lines);  /* 8B96D */
void AskExportToFloppy(unsigned char *teams, unsigned char *orig, int mode, int n);  /* 38386 */
void SplitPlayerName(char *name, char *first, char *last);  /* 6F159 */
int EventToPointer(unsigned char *ev, int *x, int *y);  /* 6B4BB */
void DrawTeamGrid(unsigned char *teams, char *title, unsigned char *grid, int arg4);  /* 37FBA */
void DrawTeamGridName(int team, unsigned char *teams, int arg4, unsigned char *grid);
void MergeGoalieRecDelta(unsigned short *old, unsigned short *cur, unsigned short *dst, int a, int b);  /* 3A826 */
int CmpGAA(int *a, int *b);  /* 1FC8F */                  
int CmpRosterGoalies(int *a, int *b);  /* 75A37 */        
void LoadTempDatabases(void);  /* 710D8 */                
void FreeLeagueDbsMem(void);
int __cdecl sub_92DE0(char *path);
int PreloadAnnouncerClips(char *home, char *vis);  /* 8579E */
void OpenSpeechBank(char *path, int n);  /* 83897 */
void QueuePenaltyType(void);
int DeskExitGame(void);  /* 1A6A7 */                      
void sub_8FCDF(int handle, int a, int b);
int sub_8FC8A(int slot, int a);
void __cdecl sub_8D2F0(int p);
void sub_B4B58(void);
void ShowCredits(void);
void noturn0(struct Player *p, short chg, short dir);  /* 5F98A */
void LoadLeagueDbsMem(char *ext);  /* 6C19B */            
void InitFileLocations(void);  /* 8BAAF */                
void *fopen(const char *name, const char *mode);
char *fgets(char *s, int n, void *fp);
int fscanf(void *fp, const char *fmt, ...);
int fclose(void *fp);
void LoadHomePals(int home, int vis);  /* 40792 */        
void LoadJerseyColours(int away, int unused, unsigned char *dst);  /* 78A87 */
void LoadDbsFromDir(char *dir, char *ext);  /* 7345B */   
void LoadTradeTeamPals(int t1, int t2, unsigned char *pal);  /* 3E835 */
int SayPlayoffTonight(char *rnk, char *away, char *home, int game, unsigned conf, unsigned round);  /* 84C38 */
void LoadTeamPalette(int home, int vis, unsigned char *pal);  /* 673C5 */
void WriteScreenTextFile(char *base);  /* 17816 */        
int fputs(const char *s, void *fp);
void ImportDbs(void);  /* 3CF5B */                        
int SelectFloppyDrive(int a, int b);
int ImportMasterLeague(void);
int ImportPlayerTeam(void);
int SelectSavedFile(void);  /* 2D099 */                   
int ReadGameSettings(void *st, char *name, int flag);
void SetupPenaltyShot(void);  /* 63F72 */                 
int SayPenalty(char *team, int num, int len, char *pen, int a, int b, int idx, int cnt, int withtime);  /* 84F7B */
void RequestTimeClips(int a, int b);
void QueueTimeClips(int a, int b);
int ReadPlayerRecs(int f1, int f2, int f3, int f4, long off, unsigned char *hdr, void *b2, unsigned n2, void *b3, unsigned n3, void *b4, unsigned n4);  /* 1C0AF */
long lseek(int fh, long pos, int how);
void SelectMatchingPlayers(char *first, char *last, int side);  /* 71690 */
char *strlwr(char *s);
void DrawGameLineJerseys(unsigned char *nums, int art, unsigned char side);  /* 78366 */
void __cdecl sub_931FC(int art, int x, int y); /* graphics library: draw art (masked) */

int CmpTeamStandings(int *a, int *b);  /* 22DDE */

void BuildTeamRosterList(int team, unsigned char *list, unsigned char **rec);  /* 6C043 */

void __cdecl sub_910E0(int art, int x, int y);  /* graphics library: draw art (opaque) */

int SimPlayoffRound1(int buf, int a, int b, char *dir, char *ext);  /* 43644 */
int SimPlayoffRound2(int buf, int a, int b, char *dir, char *ext);  /* 43E40 */
int SimPlayoffRound3(int buf, int a, int b, char *dir, char *ext);  /* 443B6 */
int SimPlayoffFinal(int buf, int a, int b, char *dir, char *ext);  /* 447A6 */
int SeedPlayoffRound2(int buf, int series, int a, int c, int *out);  /* 43757 */
int SeedPlayoffRound3(int buf, int series, int a, int c, int *out);  /* 43F4B */
int SeedPlayoffFinal(int buf, int series, int a, int c, int fh, int *out);  /* 444C9 */
void AwardsCeremony(void);  /* 13320 */
void __cdecl sub_932D0(char *path, void *buf, int size);  /* file library: write file */
int FinishPlayoffs(int fh, int a, int b, int c, char *dir, char *ext, int round);  /* 44899 */

void MoveToFreeAgents(int *mode, int *x, int *y);  /* 70E8D */
void LoadRosterList(int side);  /* 6DE94 */
void DrawEditRosters(void);  /* 6D2F8 */
void cleargamevars(void);  /* 5CD4F */
int IsCupClinched(unsigned char home, unsigned char away);  /* 15C30 */
int SeriesLength(unsigned char *s);  /* 42221 */
void SetSeriesTeams(unsigned char *s, int a, int b, int games);  /* 42F42 */
void UpdatePowerPlayFlags(void);  /* 63C73 */
int CheckBump(Player *p, Player *c);  /* 54990 */
int ChkDelayedOffside(Player *p);  /* 541CA */
int sub_B395C(void);  /* timer library: tick count */
int WaitClickTimeout(int ticks);  /* 33E6A */
void SetScreenTitle(int n);  /* 1D610 */
void QueueTimeClips(int min, int sec);  /* 84EAC */
void RequestTimeClips(int min, int sec);  /* 84DDD */
void MusicChanReset(void);  /* 837A8 */
int SpeechBusy(void);  /* 836E4 */
int IsSampleRequested(char *name);  /* 83F61 */
int OpenAnnouncerBank(void);  /* 85507 */
void ShutdownSpeech(void);  /* 8363C */
int ReadBE24(int fh);  /* 837FB */
void PlayCrowdSample(int n);  /* 59A11 */
int CrowdOnStoppage(void);  /* 4E71A */
void LoadTeamPPV(int n);  /* 66497 */
int StarEligible(int side, int pl);  /* 487D9 */
void resetplstuff(void);  /* 5E01A */
int CanRemovePlayer(Player *p);  /* 65B83 */
void lcfound(Player *p);  /* 50975 */
int POSeriesScore(unsigned char *s, int *hw, int *aw, int *home, int *away);  /* 877E9 */
int GetLeagueId(char *dir, void *out);  /* 41344 */
void PanelAddPenalty(short away, short pl, short t);  /* 14C22 */
int LineEdHitTest(int x, int y, int *item);  /* 77F6F */
void RunDeferredCalls(void);  /* 61A27 */
void GetMemStats(unsigned *total, unsigned *used, unsigned *gaps, unsigned *biggest);  /* 1002A */
int sub_B2F22(void);  /* mouse library: mouse present */
void sub_B29F0(void);  /* mouse library: init */
void InputInstall(void);  /* 6B410 */
void PrintOutlinedText(int x, int y, char *s);  /* 17636 */
void MakeTeamDbFmt(char *out, char *dir, unsigned char *tab, int n);  /* 36207 */
void IndexPhotoBank(int b);  /* 13867 */
int __cdecl sub_B30BB(int bank, char *name);  /* graphics library: find art (second entry) */
void LoadPhotoBankF(void);  /* 138D2 */
void LoadPlayerPhotos(void);  /* 1395F */
int SayGoal(char *team, int nast, int scorer, int a1, int a2);  /* 8531F */
void PaGoal(char *team, int nast, int scorer, int a1, int a2);  /* 59AD0 */
void PaPlayoffTonight(int home, int away, int game, unsigned conf, unsigned round);  /* 59D16 */
void PrintTextCopy(char *s, int x, int y);  /* 2C135 */
void SaveScheduleDB(char *buf);  /* 89223 */
void PaPenalty(char *team, int num, int len, char *pen, int a, int b, int idx, int cnt, int withtime);  /* 59B3C */
void FreeRinkGfx(void);  /* 33727 */
int FindTradeSlot(int side, unsigned char pl);  /* 3EF3C */
void DrawFrameSprite(short n, short x, short y, short a, short b);  /* 110E0 */
void deflect(Player *p);  /* 57A3E */
void ResetSpeechQueue(void);  /* 833FA */
void FreeClip(char *name);  /* 8475D */
int SayClip(char *name);  /* 84AAE */
int SayNhlIntro(void);  /* 846B4 */
int SayGoodnight(void);  /* 846C8 */
int SayLineups(void);  /* 846DC */
int SayNowBack(void);  /* 846F0 */
void FreeNowBack(void);  /* 84704 */
int SayBackMoment(void);  /* 84715 */
void FreeBackMoment(void);  /* 84729 */
int SayCoachClip(void);  /* 8473A */
void FreeCoachClip(void);  /* 8474E */
int SayElseNhl(void);  /* 847BA */
int CmpFileNames(const void *a, const void *b);  /* 2BEEA */
int NullCallback0C(int a, int b, int c, int d, int e, int f, int g);  /* 627F8 */
void StubRet4b(int a, int b, int c, int d, int e);  /* 78E29 */
int MenuLineEdCancel(int a, int b, int c, int d, int e, int f, int g, int h, int i, int j);  /* 7928A */
int DeskSetExit2(void);  /* 179D0 */
int DeskSetExit3(void);  /* 179E6 */
int SayScoringPeriod(int period, int b, int c);  /* 84A7D */
void PaScoringPeriod(int period, int b, int c);  /* 59BFC */
void PaNhlIntro(void);  /* 59C1D */
void PaGoodnight(void);  /* 59C3E */
void PaLineups(void);  /* 59C5F */
void PaElseNhl(void);  /* 59C80 */
unsigned _dos_write(int fh, void __far *buf, unsigned n, unsigned *got);  /* Watcom CRT _dos_write_ */
void ReadGSumHeader(void);  /* 61BBF */
void ReadGSumTail(void);  /* 61C22 */
void WriteGSumHeader(void);  /* 61C86 */
void DitherRect(int x, int y, int w, int h, int c);  /* 65CA8 */
void GrowToButtons(int *b, int n, int *w, int *h);  /* 30FB4 */
unsigned char FindRosterSlot(unsigned char pl, unsigned char side);  /* 739B6 */
void __cdecl sub_B5D80(int x, int y, int c);  /* B5D80: plot a pixel */
void FormatHilightDesc(char *out, unsigned char *h);  /* 7FCA2 */
int ListHitTest(int mx, int my, int left, int top, int w, int n);  /* 3023E */
void forcepldata(Team *t);  /* 5E0DD */
int PostInjuryEvent(unsigned char a, unsigned char b, unsigned char c, unsigned char d, unsigned char e, int f, int g);  /* 62764 */
void BuildEventLines(void);  /* 61E99 */
short Readjoy1(void);  /* 50A05 */
short Readjoy2(void);  /* 50A84 */
void QueueDeferredCall(void (*fn)(int, int, int, int, int, int, int), int a, int b, int c, int d, int e, int f, int g);  /* 619C8 */
void DrawBevelRect(int x, int y, int w, int h, int fill, int light, int dark);  /* 2FE49 */
void DrawGadgetButton(int n);  /* 7E067 */
int ReadTeamNames(char *path, char *out, int full);  /* 3DAB9 */
void TakePlayerFromBox(Player *p);  /* 51115 */
signed char PickForLineSlot(int side, int slot);  /* 64E60 */
void RefillLineSlots(short side, short slot, short from, short to, short step);  /* 6552E */
void __cdecl sub_B4BC4(int x1, int x2, int y1, int y2);  /* video library: clip window */
void __cdecl sub_B4C33(void);  /* video library */
void __cdecl sub_8E080(int w, int h);  /* video library: set mode size */
void __cdecl sub_B2E1B(int x, int y, int w, int h);  /* graphics library: view rect */
void SetScreenSize(int w, int h);  /* 10E9F */
int avdgoal_box(Player *p, int x1, int x2, int y, int *ps, int *pt);  /* 5F04E */
void DrawShootsField(void);  /* 6FA7D */
void DrawGloveField(void);  /* 6FB35 */
int TrackButtons(int *list, int n, int x, int y, int buttons);  /* 30A39 */
int TeamGridHitTest(int x, int y, unsigned char *tab);  /* 37B92 */
int DeskPenaltySummary(void);  /* 1A9AC */
int DeskScoringSummary(void);  /* 1AA6D */
int DeskGameStats(void);  /* 1A96D */
int ViewPlayoffHilights(void);  /* 86647 */
void WriteModeState(void *st);  /* 32B1D: the rest of its arguments come through unchanged from WriteCurModeState's caller */
void WriteCurModeState(void);  /* 8B92F */
void PaTonightIntro(int home, int away);  /* 59BB5 */
int DeskReturnConfirm(void);  /* 1A5D4 */
int TextInputDialog(char *prompt, char *buf, int len, int a, int b, int c, int d, int e, int f);  /* 2FEDF */
int OutputCurrentData(void);  /* 18D7F */
void clearteams(void);  /* 5B881 */
void PickGoalie(short side, short slot, short force);  /* 652D6 */
void checkcx(Player *p, short x, short d, short pl);  /* 58DC7 */
void checkplcoll(Player *p, short x, int y);  /* 58CE2 */
void checkpuckcoll(Player *p, int pl);  /* 5428A */
void PuckCheckColl(Player *p);  /* 548AC */
void AppendGSumRecord(void *rec);  /* 61A8A */
int SayPlayerNumber(char *team, int phrase, int number);  /* 85213 */
void LoadCrestsPalette(void);  /* 33F02 */
int __cdecl sub_B3CC8(char *path);  /* file library: check a file */
int ReadGameSettings(unsigned char *set, char *dir, int direct);  /* 2D260 */
void DrawPanelScore(short side, short score);  /* 14A20 */
void __cdecl sub_90B80(int bank, char *names, int *out);  /* graphics library: look up shapes by name list */
void LoadScoreboardGfx(void);  /* 1CC3D */
void ShowGoalieBanner(short side);  /* 671E8 */
int CopyFile(char *name, char *srcext, char *dstext, char *srcdir, char *dstdir);  /* 1466B */
int WriteLeagueInfo(char *dir, void *teams, char *pw, int b, short a, short d, short c, char *name);  /* 413CD */
int SeriesWinner(unsigned char *s, unsigned games);  /* 87760 */
void SimulateGame(char *dir, char *ext, int a, unsigned char *game, int rwfh, int rdfh, int mode);  /* 452C5 */
void POSimSeriesTo(unsigned char *lg, int n, int upto);  /* 88625 */
int MergeUpdateDbs(void);  /* 3B8B0 */
void FormatPlayerName(char *out, char *prefix, short num, char *first, char *last, char *suffix);  /* 61D48 */
void DrawTeamGridName(int team, char *names, int bm, unsigned char *tab);  /* 37C53 */
void PostGoalEvent(int t, unsigned char scorer, unsigned char a1, unsigned char a2, unsigned char b, unsigned char c, unsigned char d);  /* 62343 */
void StatsSelLeague(void);  /* 17BE7 */
int AskMasterPassword(int t, char *names, char *key);  /* 3A49E */
void EncryptPassword(char *pw, int t);  /* 3A597 */
int AskTeamPassword(int t, char *ents);  /* 3A395 */
void SaveGridCellBg(int team, unsigned char *tab, int bm, int x, int y);  /* 37D6A */
void __cdecl sub_92F50(int x1, int y1, int x2, int y2, int c);  /* graphics library: frame */
void __cdecl sub_93000(int x1, int y1, int x2, int y2, int c);  /* graphics library: erase frame */
void HighlightGridCell(int team, unsigned char *tab, int on);  /* 37EA6 */
int LeagueSetHitTest(int x, int y, int *item);  /* 7A9C8 */
void DrawSpriteNumber(short x, short y, short n, short suffix);  /* 11005 */
int LocateTeamDbCopy(unsigned char *tab, int i, char *file, char *hddir, char *flopdir, char **dir, unsigned *id);  /* 3AF70 */
void TradeDone(int a, int b, int c, int d, int e, int f, int g, int h, unsigned char *sel);  /* 3EDAA */
void ClockTick(void);  /* 5DC10 */
int CopyLeagueFiles(char *src, char *dst);  /* 3C310 */
int ReadLeagueInfo(char *dir, void *teams, char *pw, short *b, void *a, void *d, int *saved, char *name);  /* 3D8DD */
void __cdecl sub_B5DB0(int x, int y, int c);  /* graphics library: plot a pixel */
void DrawBevelBox(int x1, int y1, int x2, int y2, int studs);  /* 29D00 */
void PaPlayoffResult(int team, int game, unsigned conf, unsigned round, int ot, int final);  /* 59CDD */
int PickNearestPlayer(int x, int y);  /* 7E93E */
void DrawGadgetByType(unsigned type, unsigned char state, int b, int *shp, int c, int d);  /* 7DF4E */
void __cdecl sub_913B4(int shape);  /* graphics library: draw a shape */
void AddDirtyRect(short x, short y, short w, short h);  /* 1D02F */
int GameDressPlayer(unsigned char *nums, int a, unsigned char side, int *sel, int art, int b, int c, int d, int e, int f);  /* 79F41 */
void checkint(Player *a, Player *b);  /* 53E6A */
int __cdecl vecdist(int x, int y);  /* B3D94 */
void checkgoalp(Player *p, Player *g, short x, short y);  /* 53CE5 */
int MenuMergeUpdateDbs(void);  /* 333D7 */
void DrawLineJerseys(unsigned char *nums, int art, unsigned char side);  /* 75046 */
int FileDlgHitTest(int x, int y, int *item);  /* 2C3FF */
void a2touchpuck(Player *p);  /* 4DE14 */
void __cdecl sub_92CD0(char *s, int x, int y);  /* graphics library: print text */
void DrawDbDialogButtons(void);  /* 72605 */
int GameStandingsScreen(void);  /* 203FA */
void PruneGameLines(unsigned char side, unsigned char *lines);  /* 79090 */
void DrawSettingsHeading(int x, int y, int n, int mode, int col);  /* 8050F */
void DrawExhSetDlg(void);  /* 7C1AC */
void DrawModeSetDlg(void);  /* 7B4EC */
void DrawPhotoWithPal(unsigned char *src, int art, int x, int y);  /* 21C04 */
void __cdecl sub_91FE0(int art, int x, int y);  /* graphics library: draw art */
int MenuSoundSettings(void);  /* 82579 */
int MenuCentralRegistry(void);  /* 6BE95 */
void SetModeMenuLabels(unsigned mode);  /* 805C4 */
void DrawMenuBox(int x1, int y1, int x2, int y2, int c1, int c2, int c3);  /* 6B7FC */
void PrintMenuText(int x, int y, char *s);  /* 6B88E */
int ReadTeamRec(int fd, void *buf, int team);  /* 147C9 */
void SortStandings(int *teams, int *pts, int *wins, int *gf, int *ga, int n);  /* 42DAA */
int GetPlayoffSeeds(int *seeds, int b, int fd);  /* 42BBA */
void holdcheck(Player *a, Player *b);  /* 56B79 */
void Stop4Pen(short i);  /* 63543 */
void checkfornewpen(void);  /* 637B5 */
void skatetopuck(Player *p);  /* 5EB17 */
void assgoalietopuck(Player *p);  /* 4B5C2 */
void SteerToTarget(Player *p);  /* 492F9 */
void sub_4C8BD(Player *p);  /* 4C8BD */
void ass_pc_slot20(Player *p);  /* 49460 */
void assfaceoffp1(Player *p);  /* 4D528 */
void assdefo(Player *p);  /* 49CDD */
int BuildLeagueList(char ***list, char **names, int flags);  /* 411C8 */
void checkob(Player *p);  /* 53F8C */
short chk4lc(Player *p);  /* 54AF9 */
short chk4shot(Player *p);  /* 55804 */
short chk4pass(Player *p);  /* 55493 */
void asspuckc(Player *p);  /* 4C6F3 */
void SkateToSpot(Player *p, int a);  /* 4E292 */
void assboxenter(Player *p);  /* 499D8 */
void assscore(Player *p);  /* 4A90F */
void asspsclear(Player *p);  /* 52DB0 */
void RemoveFromLines(short side, int pnum);  /* 655CC */
void assleaveice(Player *p);  /* 4AB87 */
void assleavebox(Player *p);  /* 5147D */
void updateanim(Player *p);  /* 5CAEF */
void doshot(Player *p);  /* 57C0B */
void asspenshooter(Player *p);  /* 4FAE8 */
void PenShotAssign(void);  /* 512A7 */
void DrawMenuDropdown(void *m, int n, int x, int y, int col1, int col2, int col3);  /* 6B684 */
void DrawListItem(char *text, int x, int y, int w, int top, int idx, int sel, unsigned align, int marks, char *flags);  /* 302B9 */
void DrawListItems(char **items, int x, int y, int w, int top, int sel, int n, unsigned align, int marks, char *flags);  /* 3039C */
int MenuExhibitionSettings(void);  /* 7BEBB */
int MenuAddTeam(void);  /* 3322A */
int MenuRemoveTeam(void);  /* 332C0 */
int MenuRebuildDbs(void);  /* 3339D */
int MenuUpdateTeamDbs(void);  /* 334FB */
int MenuTradePlayers(void);  /* 33523 */
int MenuImportDbs(void);  /* 336BE */
int MenuExportDbs(void);  /* 336E6 */
int MenuLeagueSettings(void);  /* 332F6 */
int CheckGameDiskSpace(void);  /* 148A5 */

/* int-returning functions moved from asmfuncs.h */
int CmpRosterSkaters(int *a, int *b);  /* 75931 */
int LeagueSettingsDlg(void);  /* 7A13A */
int MenuPlayoffSettings(void);  /* 7A1FC */
int EditPlayoffSettings(void);  /* 7A29C */
int MenuLeagueSettingsEdit(void);  /* 7A335 */
int MenuShowLeagueSettings(void);  /* 7A39F */

int DeskTeamScratches(void);  /* 1AAC4 */
int DeskHomeGoalie1(void);  /* 1AB0B */
int DeskHomeGoalie2(void);  /* 1AB39 */
int DeskHomeGoalieNone(void);  /* 1AB62 */
int DeskAwayGoalie1(void);  /* 1AB95 */
int DeskAwayGoalie2(void);  /* 1ABC8 */
int DeskAwayGoalieNone(void);  /* 1ABF1 */
int MenuModeSettings(void);  /* 7B3A7 */
int CalStandingsScreen(void);  /* 216D7 */
int ReadSpeechSample(int n, int addr);  /* 83BF3 */
void *__cdecl _os_handle_3(int h);  /* 972F0: DOS extender, linear address of a memory handle */
#pragma aux (__cdecl) _os_handle_3 "_os_handle_3";
int __cdecl sub_98028(char *src, char *dst, int len);  /* 98028: unpack library, returns the unpacked size */
void __far *_fmemmove(void __far *dst, const void __far *src, unsigned n);  /* Watcom CRT _fmemmove_ */
void MoveSampleMem(int dst, int src, unsigned n);  /* 840A9 */
void CompactSpeechSlot(int dst, int n);  /* 84125 */
void LoadSpeechSlot(int n);  /* 83CAE */
void PlaceSpeechSlot(int n);  /* 83D78 */
void DrawDbDialog(void);  /* 727EE */
int DrawDbList(int *list);  /* 72AC6 */
int DbDialogLoop(void);  /* 72DE7 */
int DeleteSelectedDb(int *list);  /* 735C3 */
void ScanDbFiles(void);  /* 7248C */
void qsort(void *base, unsigned n, unsigned width, int (*cmp)(const void *, const void *));  /* Watcom CRT qsort_ */
#endif
