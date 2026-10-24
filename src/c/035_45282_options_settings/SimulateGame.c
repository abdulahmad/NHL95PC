/* Options settings: simulating a game without graphics. */
#define SimulateGame SimulateGame_decl
#define ReadDbRec4Ch ReadDbRec4Ch_decl
#define WriteTeamRec WriteTeamRec_decl
#include "nhl95.h"
#undef SimulateGame
#undef ReadDbRec4Ch
#undef WriteTeamRec

int SimulateGame(char *dir, char *ext, int n, unsigned char *game, int rwfh, int rdfh, int mode);
int ReadDbRec4Ch(int fh, void *rec, int n);  /* 3A2EE */
int WriteTeamRec(int fh, void *rec, int n);  /* 3A2B8 */

/* Skater stats words (season, playoff and career records). */
enum { SK_GP, SK_G, SK_A, SK_PTS, SK_PPG, SK_SHG, SK_PIM, SK_SOG, SK_PM };
/* Goalie stats words (season, playoff and career records). */
enum { GK_GP, GK_W, GK_L, GK_T, GK_SO, GK_5 /* not used here */, GK_MIN, GK_GA, GK_GAA, GK_SA, GK_SVPCT };

/* The team record (2E8h bytes, ReadTeamRec / WriteTeamRec). */
typedef struct {
    unsigned char pad0[0x28];
    unsigned char season[0x12];     /* 28h: season block (see TW) */
    unsigned char playoff[0x12];    /* 3Ah: playoff block */
    int keys[25];                   /* 4Ch: key database offsets of the skaters, -1 for none */
    int gkeys[3];                   /* B0h: of the goalies */
    unsigned char fwd[4][3];        /* BCh: forward lines (player indexes) */
    unsigned char def[3][2];        /* C8h: defense pairs */
    unsigned char ppunit[2][5];     /* CEh: power-play units */
    unsigned char pkunit[2][4];     /* D8h: penalty-kill units */
    unsigned char goalie[2];        /* E0h: the two goalie slots (19h + goalie) */
    unsigned char extra[2];         /* E2h: the extra attackers */
    unsigned char rest[0x2E8 - 0xE4];
} TeamRec;

/* A word of a team's season or playoff block (+0 games, +1 wins, +2 losses, +3 ties are bytes; +4 goals for, +6
   goals against, +8 power-play goals, +0Ah power plays, +0Ch power-play goals against, +0Eh times short-handed,
   +10h penalty minutes). */
#define TW(p, o) (*(short *)((p) + (o)))
/* The line orders: simfwdorder[2][10] (forward line numbers), simdorder[2][3] (defense pair numbers). */
#define FWD(s, l) ((int (*)[10])simfwdorder)[s][l]
#define DEF(s, l) ((int (*)[3])simdorder)[s][l]
/* Player k of side s's forward line / defense pair on the ice. */
#define FWDPL(s, k) f.t[s]->fwd[FWD(s, fline)][k]
#define DEFPL(s, k) f.t[s]->def[DEF(s, dline)][k]

/* DRAFT under Watcom 10.0 GA: 566 differing instructions, 9,872 vs 9,868 bytes. score[2] is declared before
   rate[2] (their slots then match the EXE; declsearch cannot read them). Allocation-loop indexing (i * 4 kept
   in ebp where the EXE keeps i), the err / periodlen and tick / shotv slots (not a tie: their declaration
   swap changes nothing or is worse) and later register choices remain. The allocation loop is a plain
   for (i...): routing it through sv (i = sv + 1) compiles the same. */
/* SimulateGame (452C5, PC only): play one schedule game without graphics, a minute at a time, and post it to the
   in-memory league databases. Both teams are read (rdfh: the 4Ch-byte record, its season or playoff block is not
   used afterwards; rwfh: the team record), and every dressed player's key, career and season records are found
   (season or playoff blocks: game 444h and on are playoffs). The skaters' career stats are scaled to an 84-game
   season (in place) and give the rates; the penalty rate is the team's scaled penalty minutes. Each player in a
   line gets a game played; the starting goalie is the team record's +0E0h, or +0E1h about 31% of the time, and
   gets a game. Each minute (15, 30 or 60 by the period length option; a tied playoff game goes on until it is
   decided, a tied season game gets at most 5 more minutes) the forward line order is reshuffled every 10 minutes
   and the defense pair order every 3, penalty-box time counts down, the skaters on the ice give the manpower
   advantage (95 per skater; a new power play counts a power play and a time short-handed). Then each side takes
   either a penalty (2 minutes, 5 in 6%) by the skater on the ice with the highest penalty rate, or, when its shot
   rate times the minute is high enough, a shot by its best shooter not in the box; the shot scores against a
   chance made of the shooter's shooting percentage, the opposing goalie's goals per shot, the side's goals and the
   advantage. mode 0 / 1 is the side that must win: the other side cannot score unless two goals behind, and in
   overtime mode's side always scores. A goal counts goals, points, power-play / short-handed goals, plus / minus
   for the ten skaters and up to two assists. At the end: wins / losses / ties (teams and goalies), shutouts, three
   stars (the shutout goalies are added first, but the list is then reset to 0FFh with its count kept, so they are
   lost and the next picks land after them, as in the EXE; then shots + assists + 2 goals, goals, assists; a goalie
   star counts in his goalie season record), the goalies' goals-against average and save percentage; write the
   team records back and copy each player's season record onto itself in seasondb. dir / ext: unused; n: the
   schedule game index; game: the game record (+2 home, +3 visitors, +4 / +5 the scores, set here); rwfh: the team
   database (read / write); rdfh: the database read with ReadDbRec4Ch; mode: the side that must win (0 or 1), or
   -1 / 2 for none. Result: 0, or the first file error. */
int SimulateGame(char *dir, char *ext, int n, unsigned char *game, int rwfh, int rdfh, int mode)
{
    struct {
        unsigned char assists[2][25];   /* assists this game, per player */
        unsigned char pad0[2];
        unsigned char shots[2][25];     /* shots this game */
        unsigned char pad1[2];
        unsigned char goals[2][25];     /* goals this game (at the start: line appearances) */
        unsigned char pad2[2];
        unsigned char pens[2][25];      /* penalties this game */
        unsigned char pad3[2];
        int pairs[3][2];                /* the three stars: side, player (25 + goalie for a goalie) */
        unsigned char box[2][5];        /* penalty-box minutes per skater slot (3 forwards, 2 defensemen) */
        unsigned char pad4[2];
        unsigned char lineshots[2][5];  /* shots per forward line */
        unsigned char pad5[2];
        unsigned short **apset[2];      /* skaters' career stats (season or playoff block) */
        unsigned short **gset[2];       /* goalies' season or playoff stats */
        unsigned short **agset[2];      /* goalies' career stats (season or playoff block) */
        int adv[2];                     /* manpower advantage (95 per skater, negative short-handed) */
        unsigned short **gs[2];         /* goalies' season records */
        unsigned short **aps[2];        /* skaters' career records (scaled to 84 games) */
        unsigned char **gk[2];          /* key records of the goalies */
        int team[2];                    /* the two team indexes (home, visitors) */
        unsigned char *atstats[2];      /* the 4Ch-byte record's season or playoff block (not used) */
        unsigned short **ags[2];        /* goalies' career records */
        unsigned short **ps[2];         /* skaters' season records */
        unsigned short **pset[2];       /* skaters' season or playoff stats */
        unsigned char *at[2];           /* the 4Ch-byte records read from rdfh */
        TeamRec *t[2];                  /* team records */
        unsigned char *ts[2];           /* the team record's season or playoff block */
        unsigned char **pk[2];          /* key records of the skaters */
        unsigned char *sc[2];           /* the scores in the game record */
        int pimrate[2];                 /* penalty rate (scaled penalty minutes; 1000 per penalty taken) */
        int npairs;
    } f;
    int bestshot;
    int ot;
    int shotv;
    unsigned char prevsk[2];        /* skaters on the ice the minute before */
    int err;
    unsigned char score[2];         /* goals this game */
    unsigned char dline;            /* index into simdorder */
    int tick;
    int penv;
    int i;
    unsigned char rate[2];          /* penalty rate divisor (180) */
    unsigned char fline;            /* index into simfwdorder */
    unsigned char goalie[2];        /* the goalie in net (0-2) */
    unsigned char skaters[2];       /* skaters on the ice (5 minus those in the box) */
    int j;
    int k;
    unsigned char nassists;
    int bestpen;
    int periodlen;
    unsigned char scorer;
    unsigned char assist1;
    unsigned char pl;               /* the chosen player */
    unsigned short *rec;            /* the chosen player's season or playoff stats */
    unsigned short *g;
    unsigned char slot;
    unsigned char c;
    unsigned char bside;
    unsigned char bpl;
    unsigned char mins;
    int best;
    int top;                        /* the stars' best value: never raised, as in the EXE */
    int v;
    int r;
    int sv;
    int sh;
    int chance;
    unsigned char *homeScore;

    for (i = 0; i < 2; i++) {
        for (j = 0; j < 5; j++) {
            f.box[i][j] = 0;
            f.lineshots[i][j] = 0;
        }
    }
    fline = 0;
    dline = 0;
    f.team[0] = game[2];
    f.team[1] = game[3];
    homeScore = game + 4;
    f.sc[0] = homeScore;
    f.sc[1] = game + 5;
    game[5] = game[4] = 0;
    ot = 0;
    for (i = 0; i < 2; i++) {
        f.t[i] = (TeamRec *)sub_8CCA8((char *)tag_t, 0x2E8, 0x20);
        f.at[i] = (unsigned char *)sub_8CCA8((char *)tag_at, 0x4C, 0x20);
        f.pk[i] = (unsigned char **)sub_8CCA8((char *)tag_pk, 100, 0x20);
        f.ps[i] = (unsigned short **)sub_8CCA8((char *)tag_ps, 100, 0x20);
        f.pset[i] = (unsigned short **)sub_8CCA8((char *)tag_pset, 100, 0x20);
        f.aps[i] = (unsigned short **)sub_8CCA8((char *)tag_aps, 100, 0x20);
        f.apset[i] = (unsigned short **)sub_8CCA8((char *)tag_apset, 100, 0x20);
        f.gk[i] = (unsigned char **)sub_8CCA8((char *)tag_gk, 0xC, 0x20);
        f.gs[i] = (unsigned short **)sub_8CCA8((char *)tag_gs, 0xC, 0x20);
        f.gset[i] = (unsigned short **)sub_8CCA8((char *)tag_gset, 0xC, 0x20);
        f.ags[i] = (unsigned short **)sub_8CCA8((char *)tag_ags, 0xC, 0x20);
        f.agset[i] = (unsigned short **)sub_8CCA8((char *)tag_agset, 0xC, 0x20);
    }
    err = 0;
    for (i = 0; i < 2 && !err; i++) {
        score[i] = 0;
        err = ReadDbRec4Ch(rdfh, f.at[i], f.team[i]);
        if (!err) {
            err = ReadTeamRec(rwfh, f.t[i], f.team[i]);
            if (n >= 0x444) {
                f.atstats[i] = f.at[i] + 0x3A;
                f.ts[i] = f.t[i]->playoff;
            } else {
                f.atstats[i] = f.at[i] + 0x28;
                f.ts[i] = f.t[i]->season;
            }
            rate[i] = 0xB4;
            f.pimrate[i] = 0;
        }
    }
    for (i = 0; i < 2 && !err; i++) {
        for (j = 0; j < 25 && !err; j++) {
            f.pens[i][j] = 0;
            f.shots[i][j] = 0;
            f.assists[i][j] = 0;
            f.goals[i][j] = 0;
            if (f.t[i]->keys[j] != -1) {
                f.pk[i][j] = KeyDbPtr(f.t[i]->keys[j]);
                if (!err) {
                    f.aps[i][j] = (unsigned short *)CareerDbPtr(*(int *)(f.pk[i][j] + 0x28));
                    /* scale the career stats to an 84-game season */
                    f.aps[i][j][SK_SOG] = f.aps[i][j][SK_SOG] * 84 / f.aps[i][j][SK_GP];
                    f.aps[i][j][SK_PIM] = f.aps[i][j][SK_PIM] * 84 / f.aps[i][j][SK_GP];
                    f.aps[i][j][SK_SHG] = f.aps[i][j][SK_SHG] * 84 / f.aps[i][j][SK_GP];
                    f.aps[i][j][SK_PPG] = f.aps[i][j][SK_PPG] * 84 / f.aps[i][j][SK_GP];
                    f.aps[i][j][SK_A] = f.aps[i][j][SK_A] * 84 / f.aps[i][j][SK_GP];
                    f.aps[i][j][SK_G] = f.aps[i][j][SK_G] * 84 / f.aps[i][j][SK_GP];
                    f.aps[i][j][SK_PTS] = f.aps[i][j][SK_G] + f.aps[i][j][SK_A];
                    f.aps[i][j][SK_GP] = 84;
                    if (n >= 0x444)
                        f.apset[i][j] = f.aps[i][j] + 9;
                    else
                        f.apset[i][j] = f.aps[i][j];
                    f.pimrate[i] += f.aps[i][j][SK_PIM];
                }
                if (!err) {
                    f.ps[i][j] = (unsigned short *)SeasonDbPtr(*(int *)(f.pk[i][j] + 0x2C));
                    if (n >= 0x444)
                        f.pset[i][j] = f.ps[i][j] + 9;
                    else
                        f.pset[i][j] = f.ps[i][j];
                }
            }
        }
        for (j = 0; j < 3 && !err; j++) {
            if (f.t[i]->gkeys[j] != -1) {
                f.gk[i][j] = KeyDbPtr(f.t[i]->gkeys[j]);
                if (!err) {
                    f.ags[i][j] = (unsigned short *)CareerDbPtr2(*(int *)(f.gk[i][j] + 0x28));
                    if (n >= 0x444)
                        f.agset[i][j] = f.ags[i][j] + 11;
                    else
                        f.agset[i][j] = f.ags[i][j];
                }
                if (!err) {
                    f.gs[i][j] = (unsigned short *)SeasonDbPtr2(*(int *)(f.gk[i][j] + 0x2C));
                    if (n >= 0x444)
                        f.gset[i][j] = f.gs[i][j] + 11;
                    else
                        f.gset[i][j] = f.gs[i][j];
                }
            }
        }
    }
    for (i = 0; i < 2 && !err; i++) {
        skaters[i] = 5;
        f.pimrate[i] = f.pimrate[i] * 1000 / 84;
        if ((rand() & 0x7FFF) % 1000 > 310)
            goalie[i] = f.t[i]->goalie[0] - 0x19;
        else
            goalie[i] = f.t[i]->goalie[1] - 0x19;
        f.ts[i][0]++;
        f.gset[i][goalie[i]][GK_GP]++;
        /* a game played for each skater in a line */
        for (j = 0; j < 25; j++)
            f.goals[i][j] = 0;
        for (j = 0; j < 4; j++) {
            for (k = 0; k < 3; k++) {
                c = f.t[i]->fwd[j][k];
                if (c < 25)
                    f.goals[i][c]++;
            }
        }
        for (j = 0; j < 3; j++) {
            for (k = 0; k < 2; k++) {
                c = f.t[i]->def[j][k];
                if (c < 25)
                    f.goals[i][c]++;
            }
        }
        for (j = 0; j < 2; j++) {
            for (k = 0; k < 5; k++) {
                c = f.t[i]->ppunit[j][k];
                if (c < 25)
                    f.goals[i][c]++;
            }
        }
        for (j = 0; j < 2; j++) {
            for (k = 0; k < 4; k++) {
                c = f.t[i]->pkunit[j][k];
                if (c < 25)
                    f.goals[i][c]++;
            }
        }
        for (j = 0; j < 2; j++) {
            c = f.t[i]->extra[j];
            if (c < 25)
                f.goals[i][c]++;
        }
        for (j = 0; j < 25; j++) {
            if (f.goals[i][j] != 0)
                f.pset[i][j][SK_GP]++;
            f.goals[i][j] = 0;
        }
    }
    if (gameopts.pertime == 2)
        periodlen = 60;
    else if (gameopts.pertime == 1)
        periodlen = 30;
    else
        periodlen = 15;

    for (j = 0, tick = 0; j < periodlen && !err; j++, tick++) {
        if (fline == 0) {
            for (i = 0; i < 2; i++) {
                for (k = 0; k < 10; k++) {
                    r = RandMod(10);
                    if (r != k) {
                        FWD(i, k) ^= FWD(i, r);
                        FWD(i, r) ^= FWD(i, k);
                        FWD(i, k) ^= FWD(i, r);
                    }
                }
            }
        }
        if (dline == 0) {
            for (i = 0; i < 2; i++) {
                for (k = 0; k < 3; k++) {
                    r = RandMod(3);
                    if (r != k) {
                        DEF(i, k) ^= DEF(i, r);
                        DEF(i, r) ^= DEF(i, k);
                        DEF(i, k) ^= DEF(i, r);
                    }
                }
            }
        }
        /* penalty-box time and the skaters on the ice */
        for (i = 0; i < 2; i++) {
            prevsk[i] = skaters[i];
            skaters[i] = 0;
            for (k = 0; k < 5; k++) {
                if (f.box[i][k] > 0)
                    f.box[i][k]--;
                if (f.box[i][k] == 0)
                    skaters[i]++;
            }
            f.adv[i] = 0;
        }
        if (prevsk[0] != skaters[0] || prevsk[1] != skaters[1]) {
            if (skaters[0] > skaters[1] && prevsk[0] <= prevsk[1]) {
                TW(f.ts[0], 0xA)++;
                TW(f.ts[1], 0xE)++;
            } else if (skaters[1] > skaters[0] && prevsk[1] <= prevsk[0]) {
                TW(f.ts[1], 0xA)++;
                TW(f.ts[0], 0xE)++;
            }
        }
        if (skaters[0] > skaters[1]) {
            f.adv[0] = (skaters[0] - skaters[1]) * 95;
            f.adv[1] = -f.adv[0];
        } else if (skaters[1] > skaters[0]) {
            f.adv[1] = (skaters[1] - skaters[0]) * 95;
            f.adv[0] = -f.adv[1];
        }
        for (i = 0; i < 2; i++) {
            r = RandMod(1000);
            if (r < f.pimrate[i] / rate[i]) {
                /* a penalty: the skater on the ice with the most penalty minutes (less 1000 per penalty taken) */
                slot = 0xFF;
                for (k = 0; k < 3; k++) {
                    c = FWDPL(i, k);
                    penv = f.aps[i][c][SK_PIM] * 1000 / 84 / 60 - f.pens[i][c] * 1000;
                    if (slot == 0xFF || penv > bestpen) {
                        rec = f.pset[i][c];
                        slot = k;
                        bestpen = penv;
                        pl = c;
                    }
                }
                for (k = 0; k < 2; k++) {
                    c = DEFPL(i, k);
                    penv = f.aps[i][c][SK_PIM] * 1000 / 84 / 60 - f.pens[i][c] * 1000;
                    if (penv > bestpen) {
                        rec = f.pset[i][c];
                        slot = k + 3;
                        bestpen = penv;
                        pl = c;
                    }
                }
                if (f.box[i][slot] == 0) {
                    if (RandMod(1000) < 60)
                        mins = 5;
                    else
                        mins = 2;
                    f.box[i][slot] = mins + 1;
                    rec[SK_PIM] += mins;
                    f.pens[i][pl]++;
                    TW(f.ts[i], 0x10) += mins;
                    f.pimrate[i] -= 1000;
                }
            } else {
                /* the shot rate: the goalie's career shots against and the five skaters' shots */
                r = f.ags[i][goalie[i]][GK_SA] * 1000 / 84 / 60;
                for (k = 0; k < 3; k++)
                    r += f.aps[i][FWDPL(i, k)][SK_SOG] * 1000 / 84 / 60;
                for (k = 0; k < 2; k++)
                    r += f.aps[i][DEFPL(i, k)][SK_SOG] * 1000 / 84 / 60;
                if (r * (tick + 1) - f.lineshots[i][FWD(i, fline)] * 1000 > 1000) {
                    /* a shot by the skater on the ice (not in the box) with the most shots still due */
                    slot = 0xFF;
                    for (k = 0; k < 3; k++) {
                        c = FWDPL(i, k);
                        shotv = f.aps[i][c][SK_SOG] * 1000 / 84 / 60 - f.shots[i][c] * 1000;
                        if ((slot == 0xFF || shotv > bestshot) && f.box[i][k] == 0) {
                            rec = f.pset[i][c];
                            slot = k;
                            bestshot = shotv;
                            pl = c;
                        }
                    }
                    for (k = 0; k < 2; k++) {
                        c = DEFPL(i, k);
                        shotv = f.aps[i][c][SK_SOG] * 1000 / 84 / 60 - f.shots[i][c] * 1000;
                        if (shotv > bestshot && f.box[i][k + 3] == 0) {
                            rec = f.pset[i][c];
                            bestshot = shotv;
                            pl = c;
                        }
                    }
                    f.lineshots[i][FWD(i, fline)]++;
                    f.shots[i][pl]++;
                    rec[SK_SOG]++;
                    f.gset[i][goalie[i]][GK_SA]++;  /* the shooting side's own goalie, as in the EXE */
                    g = f.ags[i ^ 1][goalie[i ^ 1]];
                    if (g[GK_SA] != 0)
                        sv = g[GK_GA] * 1000 / g[GK_SA];
                    else
                        sv = (rand() & 0x7FFF) % 10 + 1;
                    sv -= score[i] * 1000 / 33;
                    g = f.aps[i][pl];
                    if (g[SK_SOG] != 0)
                        sh = g[SK_G] * 1000 / g[SK_SOG];
                    else
                        sh = (rand() & 0x7FFF) % 10 + 1;
                    if (tick >= periodlen && mode == i)
                        chance = 1000;
                    else
                        chance = (sh + sv) / 2 + f.adv[i] + 13;
                    r = RandMod(1000);
                    if ((mode == 0 || mode == 1) && i != mode) {
                        if (score[i ^ 1] - 1 <= score[i] || score[i ^ 1] == 0)
                            r = chance + 1;
                    }
                    if (r <= chance) {
                        /* a goal */
                        scorer = pl;
                        rec[SK_G]++;
                        rec[SK_PTS]++;
                        f.goals[i][pl]++;
                        f.gset[i ^ 1][goalie[i ^ 1]][GK_GA]++;
                        TW(f.ts[i], 4)++;
                        (*f.sc[i])++;
                        score[i]++;
                        if (f.adv[i] > 0) {
                            TW(f.ts[i], 8)++;
                            rec[SK_PPG]++;
                            TW(f.ts[i ^ 1], 0xC)++;
                        }
                        TW(f.ts[i ^ 1], 6)++;
                        if (f.adv[i] < 0)
                            rec[SK_SHG]++;
                        for (k = 0; k < 3; k++) {
                            f.pset[i][FWDPL(i, k)][SK_PM]++;
                            f.pset[i ^ 1][FWDPL(i ^ 1, k)][SK_PM]--;
                        }
                        for (k = 0; k < 2; k++) {
                            f.pset[i][DEFPL(i, k)][SK_PM]++;
                            f.pset[i ^ 1][DEFPL(i ^ 1, k)][SK_PM]--;
                        }
                        nassists = 0;
                        r = RandMod(1000);
                        if (r <= 800 && skaters[i] >= 2)
                            nassists = 2;
                        else if (r <= 900 && skaters[i] >= 1)
                            nassists = 1;
                        assist1 = 0xFF;
                        while (nassists != 0) {
                            /* the skater on the ice (not in the box, not the scorer or the first assist) with
                               the most assists still due */
                            slot = 0xFF;
                            for (k = 0; k < 3; k++) {
                                c = FWDPL(i, k);
                                v = f.aps[i][c][SK_A] * 1000 / 84 / 60 - f.assists[i][c] * 1000;
                                if ((slot == 0xFF || v > best) && f.box[i][k] == 0 && c != scorer && c != assist1) {
                                    rec = f.pset[i][c];
                                    slot = k;
                                    best = v;
                                    pl = c;
                                }
                            }
                            for (k = 0; k < 2; k++) {
                                c = DEFPL(i, k);
                                v = f.aps[i][c][SK_A] * 1000 / 84 / 60 - f.assists[i][c] * 1000;
                                if ((slot == 0xFF || v > best) && f.box[i][k + 3] == 0 && c != scorer
                                    && c != assist1) {
                                    rec = f.pset[i][c];
                                    slot = k + 3;
                                    best = v;
                                    pl = c;
                                }
                            }
                            if (slot != 0xFF) {
                                assist1 = pl;
                                f.assists[i][pl]++;
                                rec[SK_A]++;
                                rec[SK_PTS]++;
                                nassists--;
                            } else {
                                nassists = 0;
                            }
                        }
                    }
                }
            }
            f.gset[i][goalie[i]][GK_MIN]++;
        }
        if (++fline == 10)
            fline = 0;
        if (++dline == 3)
            dline = 0;
        /* overtime: a tied playoff game replays its last minute until it is decided, a season game at most 5
           times */
        if (periodlen - 1 == j) {
            if (n >= 0x444) {
                if (*f.sc[0] == *f.sc[1])
                    j--;
            } else if (*f.sc[0] == *f.sc[1] && ot < 5) {
                ot++;
                j--;
            }
        }
    }

    if (*f.sc[0] == *f.sc[1]) {
        f.ts[0][3]++;
        f.ts[1][3]++;
        f.gset[0][goalie[0]][GK_T]++;
        f.gset[1][goalie[1]][GK_T]++;
    } else if (*f.sc[0] > *f.sc[1]) {
        f.ts[0][1]++;
        f.ts[1][2]++;
        f.gset[0][goalie[0]][GK_W]++;
        f.gset[1][goalie[1]][GK_L]++;
    } else {
        f.ts[1][1]++;
        f.ts[0][2]++;
        f.gset[1][goalie[1]][GK_W]++;
        f.gset[0][goalie[0]][GK_L]++;
    }
    f.npairs = 0;
    if (*f.sc[0] == 0) {
        f.gset[1][goalie[1]][GK_SO]++;
        SimAddPair(&f.npairs, (int *)f.pairs, 1, goalie[1] + 0x19);
    }
    if (*f.sc[1] == 0) {
        f.gset[0][goalie[0]][GK_SO]++;
        SimAddPair(&f.npairs, (int *)f.pairs, 0, goalie[0] + 0x19);
    }
    for (i = 0; i < 3 && !err; i++) {
        for (j = 0; j < 2 && !err; j++)
            f.pairs[i][j] = 0xFF;
    }
    /* three stars: the last player with any shots or points, the last with a goal, the last with an assist (top
       stays 0, so each pick is the last player above 0, else home player 0) */
    bpl = bside = 0xFF;
    top = 0;
    for (i = 0; i < 2 && !err; i++) {
        for (j = 0; j < 25 && !err; j++) {
            v = f.goals[i][j] * 2 + f.assists[i][j] + f.shots[i][j];
            if (bpl == 0xFF || v > top) {
                bside = i;
                bpl = j;
            }
        }
    }
    if (bside != 0xFF)
        SimAddPair(&f.npairs, (int *)f.pairs, bside, bpl);
    bpl = bside = 0xFF;
    top = 0;
    for (i = 0; i < 2 && !err; i++) {
        for (j = 0; j < 25 && !err; j++) {
            v = f.goals[i][j];
            if (bpl == 0xFF || v > top) {
                bside = i;
                bpl = j;
            }
        }
    }
    if (bside != 0xFF)
        SimAddPair(&f.npairs, (int *)f.pairs, bside, bpl);
    bpl = bside = 0xFF;
    top = 0;
    for (i = 0; i < 2 && !err; i++) {
        for (j = 0; j < 25 && !err; j++) {
            v = f.assists[i][j];
            if (bpl == 0xFF || v > top) {
                bside = i;
                bpl = j;
            }
        }
    }
    if (bside != 0xFF)
        SimAddPair(&f.npairs, (int *)f.pairs, bside, bpl);
    for (i = 0; i < 3 && !err; i++) {
        bside = f.pairs[i][0];
        bpl = f.pairs[i][1];
        if (bside != 0xFF && bpl != 0xFF) {
            if (f.pk[bside][bpl][2] == 'G')
                f.gs[bside][bpl][0x18 + i]++;
            else
                f.ps[bside][bpl][0x14 + i]++;
        }
    }
    /* goals-against average (per hundred) and save percentage (per thousand) of the goalies in net */
    for (i = 0; i < 2; i++) {
        g = f.gset[i][goalie[i]];
        if (g[GK_GP] != 0)
            g[GK_GAA] = g[GK_GA] * 100 / g[GK_GP];
        else
            g[GK_GAA] = 0;
        g = f.gset[i][goalie[i]];
        g[GK_SVPCT] = g[GK_SA] != 0 ? ((g[GK_SA] - g[GK_GA]) * 1000 + g[GK_SA] / 2) / g[GK_SA] : 0;
    }
    for (i = 0; i < 2 && !err; i++) {
        err = WriteTeamRec(rwfh, f.t[i], f.team[i]);
        for (j = 0; j < 25 && !err; j++) {
            if (f.t[i]->keys[j] != -1)
                memcpy(seasondb + *(int *)(f.pk[i][j] + 0x2C), f.ps[i][j], 0x2F);
        }
        for (j = 0; j < 3 && !err; j++) {
            if (f.t[i]->gkeys[j] != -1)
                memcpy(seasondb + *(int *)(f.gk[i][j] + 0x2C), f.gs[i][j], 0x2F);
        }
    }
    for (i = 0; i < 2; i++) {
        FreeMemBlock((int)f.agset[i]);
        FreeMemBlock((int)f.ags[i]);
        FreeMemBlock((int)f.gset[i]);
        FreeMemBlock((int)f.gs[i]);
        FreeMemBlock((int)f.gk[i]);
        FreeMemBlock((int)f.apset[i]);
        FreeMemBlock((int)f.aps[i]);
        FreeMemBlock((int)f.pset[i]);
        FreeMemBlock((int)f.ps[i]);
        FreeMemBlock((int)f.pk[i]);
        FreeMemBlock((int)f.at[i]);
        FreeMemBlock((int)f.t[i]);
    }
    return err;
}
