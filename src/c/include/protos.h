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
void __cdecl sub_8E8B8(char *name, int bank);  /* sound library loader, stack args */
void NudgeRinkScroll(void);  /* 7FC12 */                  
void ClampYPosition(Player *p);  /* 4B6F4 */              
void CrowdFadeOut(void);
void __cdecl sub_B3989(int n);  /* timer library, stack args */
void __cdecl sub_B3999(void);  /* timer library */        
void PaPreloadClips(int a, int b);
int PreloadAnnouncerClips(int a, int b);  /* 8579E: 0 = not done yet */
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
void PaPenaltyShot(int a);
void SayPenaltyShot(int a);  /* 8511E */                  
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
void SayHighlightIntro(int a, int b, int c);  /* 847CE */ 
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
void __cdecl FatalError(char *msg);  /* B2CD8 */          
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
void AddPenalty2(void *obj, int kind);
void newcheck(short kind);  /* 58084 */                   
int FreeUnrequestedSamples(void);  /* 84036 */            
int IsSampleRequested(SpeechSlot *s);
int a2offsides(Player *p);  /* 4DCDD */                   
void AddPenalty(Player *p, int kind);
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

#endif
