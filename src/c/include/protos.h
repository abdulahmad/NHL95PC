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

#endif
