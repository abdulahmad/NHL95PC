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
extern short *puckx;          /* C907C: points at the puck's x word (puckstruct+2; 93G puckx) */
extern short *pucky;          /* C9084: points at the puck's y word (puckstruct+6) */
extern short *puckvx;         /* C9080: points at the puck's x velocity word (puckstruct+0Ch) */
extern short *puckvy;         /* C9088: points at the puck's y velocity word (puckstruct+0Eh) */
extern signed char *puckc;   /* C9094: points at the puck's controller byte (SortCords number of the carrier, -1 none; 93G puckc) */
/* regd0-regd4: the 68k data registers of the Genesis code, kept as 4-byte statics. The PC code reads and writes
   them as words (.w, the 68k .w ops) and as whole longs (.l / .ul, the .l ops and unsigned compares). */
typedef union Reg68 {
    short w;
    long l;
    unsigned long ul;
} Reg68;
extern Reg68 regd0;     /* E03BC */
extern Reg68 regd1;     /* E03C0 */
extern Reg68 regd2;     /* E03AC */
extern Reg68 regd3;     /* E03B0 */
extern Reg68 regd4;     /* E03B4 */
#endif
