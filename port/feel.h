/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * The feel options of 95 PC (the Game page): skating as 95 PC has it, or as 94 Genesis had it, per pixel or
 * scaled to 95 PC's shorter rink, with the cartridge's timing or the C port's Smooth one. The game's own code
 * stays: playeracc and stopna are run by C copies here (port/feel.c), and the friction and turn constants are
 * written in place. With every option on 95 PC the copies do what the game's routines do.
 */
#ifndef NHL95_FEEL_H
#define NHL95_FEEL_H

#include <overbar/overbar.h>

/* where a feature's numbers come from */
enum { FEEL_95PC = 0, FEEL_94G_PIXEL = 1, FEEL_94G_RINK = 2 };

typedef struct feel_profile {
    int speed;          /* top speed: FEEL_* */
    int accel;          /* acceleration: FEEL_* */
    int stop;           /* stopping: FEEL_* */
    int glide;          /* 1: 94G's glide (the cartridge's friction per frame: half of 95 PC's) */
    int turn;           /* 1: 94G's turn rate (Cartridge: 14/16 of 95 PC's per frame, the cart's ~51 passes a second) */
    int cartridge;      /* 94G timing: 1 the cartridge (about 30 passes a second), 0 Smooth (60) */
} feel_profile;

/* the Game page's options (after ob_host_init, before the menu bar is built); reads the game_ lines of ini_path */
void feel_register(ob_host *h, const char *ini_path);
/* the hooks and the constants; after install_overrides */
void feel_install(void);
/* the profile the game runs with now */
const feel_profile *feel_now(void);
/* settings_save writes these (the port's ini) */
void feel_write_ini(FILE *f);
/* online play: the host's options for the session (text of ob_game_pack), and back to this machine's after it;
 * neither writes the ini */
void feel_session_begin(const char *text, size_t size);
void feel_session_end(void);

/* the C copies, for port/feel_test.c */
void feel_playeracc(uint8_t *p, int dir);
void feel_stopna(uint8_t *p);
void feel_set_profile(const feel_profile *f);

/* the Game page's Fights row (port/fight/hooks.c): 1 on */
int feel_fights(void);
/* the Game page's names box row: 0 the box moves to the top right when a fighter is under it, 1 it hides */
int feel_fight_box(void);
/* the Game page's debug row: the next hit that may start a fight does (cleared once it has) */
int feel_fight_next(void);
void feel_fight_next_done(void);

#endif
