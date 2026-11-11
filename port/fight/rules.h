/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * NHLPA 93's fight, as 95 PC's own code (port/fight/rules.c): a C copy of 93's checkfight and SetInst (hockey93.asm),
 * fightinput, assfight and chkhit (logic93.asm), and the animations they use (frames93.asm), on two fighters of its
 * own. The game side (port/fight/hooks.c, to come) copies the two players in, runs fight_pass once a frame with the
 * game's random numbers, and copies positions, velocities and frames back; it plays the sounds, calls the penalties
 * and moves the crowd from the events.
 *
 * Numbers are 93's. Ratings are 0-15 as in 95 PC: 93's fighting rating is the roster nibble with bit 0 cleared
 * (0-14 even), its checking rating the nibble. Durations count 60 Hz frames (93 subtracts the frames that passed).
 */
#ifndef NHL95_FIGHT_RULES_H
#define NHL95_FIGHT_RULES_H

#include <stdint.h>

/* 93's fight animations (SPA): frame and duration lists per facing (frames93.asm) */
enum { FA_NONE, FA_FIGHT, FA_GRAB, FA_HELD, FA_HIGH, FA_LOW, FA_HITHIGH, FA_HITLOW, FA_FALL, FA_INJURY, FA_COUNT };

/* events of a pass (fight.events) */
enum {
    FE_GLOVES = 1 << 0,         /* gloves dropped: the glove sprite at glove_x, glove_y */
    FE_BANNER = 1 << 1,         /* show the fighters' names */
    FE_PUNCH_HIGH = 1 << 2,     /* the high punch sound */
    FE_PUNCH_LOW = 1 << 3,
    FE_WINNER = 1 << 4,         /* fighter `winner`'s penalty becomes "Fighting *" */
    FE_INJURY = 1 << 5,         /* the loser is hurt: out, bloody animation */
    FE_CHEER = 1 << 6,          /* the crowd cheers (the visitors lost) */
    FE_BOO = 1 << 7,            /* the home team lost */
    FE_OVER = 1 << 8            /* the stoppage is done: play resets for the penalties */
};

/* pad bits for a human fighter */
enum { FP_A = 1, FP_B = 2, FP_C = 4 };      /* grab, low punch, high punch: new presses */

typedef struct fighter {
    /* the game's, copied in and out */
    int x, y;                   /* pixels */
    int xvel, yvel;             /* the game's velocity units */
    int facedir;                /* 2 or 5 while fighting */
    int human;
    int fighting, checking;     /* 0-15 */
    int energy;                 /* 0-1000h */
    int away;                   /* 1: the visiting team */
    /* the fight's */
    int spa, spanum, spacnt, frame, oldframe, glitch, alock, aip, flip;
    int strength;               /* temp3: punches it can take; -1 once it has won */
    int banner;                 /* temp4 */
    int started;
    int injured;
    int gloves_on;              /* pf2npc: no collisions until the gloves are off */
} fighter;

typedef struct fight {
    fighter f[2];
    int on;
    int xc1, yc1;               /* the fight's spot (the camera locks there) */
    int pencnt;                 /* the stoppage count-down */
    int glove_x, glove_y;       /* 93's glovecords: x / 4 (never 0), y / 4 */
    int crowd, excite;          /* added to the crowd level and excitement */
    unsigned events;
    int winner, loser;          /* 0 or 1, after FE_WINNER */
    int (*random)(void *ctx, int range);        /* the game's randomd0: 0..range-1 */
    void *ctx;
} fight;

/* 93's SetInst both ways (checkfight): would these two fight? chkcnt = checks this period (ChkCnt), checks_* = each
 * player's own checks. *instigator is set to 0 or 1 (the player whose teammate takes the instigator penalty, 1 time
 * in 4 with penalties on) or -1. The rest of checkfight (both impacts 10+, no animation lock, no penalty, no goalie,
 * the clock running, no faceoff) is the game side's. */
int fight_wants(const fighter *a, const fighter *b, int chkcnt, int checks_a, int checks_b, int penalties_on,
                int (*random)(void *ctx, int range), void *ctx, int *instigator);
/* 93 setplayer: fighting is the roster check byte with bit 0 cleared (handed). 0, 2, 4 ... 14. */
int fight_rating_byte(int roster_byte);
/* 93 FallDown: a knockdown adds 1 to ChkCnt, and 2 more when the hitter's fighting rating is 0. */
int fight_check_weight(int fighting);
/* checkfight's set-up: face each other, pushed apart, gloves off (fight.f must be filled in) */
void fight_begin(fight *ft);
/* one game frame: pad[i] = dpad direction 0-7 (8 none) | FP_* << 4 for a human fighter */
void fight_pass(fight *ft, int elapsed, const int pad[2], void (*accel)(void *ctx, int who, int dir));

/* an animation's frames, for the drawing side: 93 frame numbers (rom93.h) */
int fight_anim_frame(int spa, int facedir, int step, int *duration);

#endif
