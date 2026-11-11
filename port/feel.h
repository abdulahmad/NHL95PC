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

/* the Game page's Auto line changes row (port/lines.c): 1 on. 96 PC's Auto state. */
int feel_auto_lines(void);
/* the Game page's Manual goalie row (port/goalie.c): 1 on. 96 PC Manual; 94G move/save. */
int feel_auto_fly(void);             /* Auto line changes on the fly (96 PC) as well as at faceoffs (94 Genesis) */
int feel_manual_goalie(void);
int feel_fake_pads(void);            /* Debug: two pretend controllers, so a 1 v 1 plays as 2 v 2 (pads 3 and 4) */
int feel_four_players(void);         /* 1: pads 3 and 4 and the 94 stars and arrows. 0: the game's two pads only */
int feel_console_fake(void);         /* 1: 95 Genesis A-tap fake shot in the offensive zone. Default off. Locked online */
int feel_clear_puck(void);           /* 1: 94 Genesis A-tap flip out of the defensive zone. Default off. Locked online */
int feel_goalie_button(void);        /* 1: Manual goalie is its own button. 0: hold pass. Locked online */
void feel_set_console_fake(int on);
void feel_set_clear_puck(int on);
void feel_set_goalie_button(int on);
/* the Game page's Skill level row (port/skill.c): 0 rookie, 1 pro, 2 all-star.
 * Pro is 1× the current feel; All-Star/Rookie scale off that. */
int feel_skill(void);

#endif
