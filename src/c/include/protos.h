/* protos.h - prototypes of the functions written in C (every matched function goes here) and of asm functions
   whose register signature is known. Watcom register convention (-5r): arguments in eax, edx, ebx, ecx, then the
   stack; result in eax. Keep the asm label as the name. */
#ifndef PROTOS_H
#define PROTOS_H
struct Player; struct Team;

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
int SpeechBusy(void);                                     /* announcer sample still playing? */
int OpenAnnouncerBank(void);                              /* 0 = failed */
short sub_8F80E(int handle);                              /* sound library: sample finished? */

#endif
