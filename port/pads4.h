/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * Four players on 95 PC: pads 3 and 4, the way 94 Genesis added them to this engine.
 */
#ifndef NHL95_PADS4_H
#define NHL95_PADS4_H

#include <stdint.h>

#define PADS4_NONE (-1)         /* a pad with no device: no direction, no buttons */
#define PADS4_REMOTE (-2)       /* online: another machine's, from the step records */
#define PADS4_FAKE (-3)         /* the Game page's pretend controller: no input */

/* What the game's own two controller slots cannot hold: pads 3 and 4 (k = 0, 1). It sits in one block so
 * that a rollback state can take it with the game's data. */
typedef struct pads4_state {
    int16_t team[2];            /* 0 none, 1 home, 2 away (as cont1team) */
    int16_t player[2];          /* SortCords number, -1 none (as c1playernum) */
    int16_t lj[2];              /* the buttons at the last read (as lj1) */
    uint8_t bhold[2];           /* the manual goalie's B-hold timer (goalie.c's per pad) */
    int8_t src[2];              /* SDL pad index, or PADS4_NONE / REMOTE / FAKE */
} pads4_state;

extern pads4_state pads4;

void pads4_install(void);
void pads4_clear(void);
/* pad k (0: pad 3, 1: pad 4) plays team (1 home, 2 away; 0 none) from src */
void pads4_set(int k, int team, int src);
/* the Game page's "pretend controllers" after the game's own set-up (no select-sides screen) */
void pads4_fake_fill(void);
/* online: pad k's byte from this machine's controller (8 none); remote pads leave when the session does */
uint8_t pads4_local_byte(int k);
void pads4_drop_remote(void);
/* each game frame before updateplayers (port/fight/hooks.c): pads 3 and 4 keep or pick their players, faceoffs too */
void pads4_tick(void);
/* the pad (0: pad 3, 1: pad 4) that has SortCords number sc, or -1; pads4_fake: it is a pretend controller's */
int pads4_owner(int sc);
int pads4_fake(int k);

/* Seats to slots. n seats (each: team 1 home / 2 away, kb 1 for the keyboard). out[i]: the game slot of
 * seat i, 0 and 1 the game's own controllers, 2 and 3 pads 3 and 4, -1 none. Slot 0 is the first seat;
 * slot 1 the first seat of the other team, else the second seat; a keyboard seat is always a game slot
 * (only the game reads the keyboard pad). With two seats or fewer, seat i is slot i. */
void pads4_map_seats(int n, const int *team, const int *kb, int *out);

/* the pad byte as the game's ReadJoyPad makes it: direction mask (1 up, 2 down, 4 right, 8 left) and buttons */
uint8_t pads4_byte(int mask, int pass, int shoot);

/* is SortCords number sc a player pad k may keep: on the ice for team (1 home: 0-5, 2 away: 6-11),
 * no other pad's; position and pflags2 are his */
int pads4_keep(int sc, int team, int position, int pflags2, const int16_t *others, int nothers);

#endif
