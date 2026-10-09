/* vars.h - hand-written declarations of globals whose type is known (overrides the type tools/gen_cheaders.py
   infers in globals.h; re-run that tool after adding a name here). Keep the asm label as the name. */
#ifndef VARS_H
#define VARS_H
struct Player;
/* gameopts (C53FF, dword): game option bits; default 0FFh in the low byte */
typedef struct GameOpts {
    unsigned optbit0:1;
    unsigned offsides:1;        /* bit 1: offsides on (EvadePC, 93G gmoffs) */
    unsigned linechanges:1;     /* bit 2: line changes / fatigue on (playeracc energy drain, lcselect) */
    unsigned twolinepass:1;     /* bit 3: two-line pass whistle (ChkTwoLinePass) */
    unsigned optbit4:1;
    unsigned optbit5:1;
    unsigned music:1;           /* bit 6: music on (Ctrl+M in HandleHotKey) */
    unsigned sfx:1;             /* bit 7: sound effects on (Ctrl+S) */
    unsigned speech:1;          /* bit 8: announcer speech on (the Pa* wrappers) */
    unsigned fullot:1;          /* bit 9: overtime periods are full length (GetPeriodTime) */
    unsigned pertime:2;         /* bits 10-11: period length option, PerTimeTab index */
    unsigned optrest:20;
} GameOpts;
extern GameOpts gameopts;
struct Team;
extern struct Team hmtmstruct;      /* DF614: home team structure (93G hmtmstruct) */
extern struct Team awtmstruct;      /* DF714: away team structure (93G awtmstruct) */
extern struct Player SortCords[];
extern unsigned char *replaystart;  /* C9078: start of the replay buffer (frames of 80h bytes, 9600h bytes) */
extern unsigned char *recbpr;       /* E039C: replay record pointer (next frame to write) */   /* DF81C: player structures, 80h each; home 0-5, away 6-11 (+300h) (93G SortCords) */
#endif
