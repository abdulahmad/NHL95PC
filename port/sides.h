/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * 95 PC's hook for Overbar's select-sides screen (overbar/sides.h). The screen
 * itself is Overbar's; this file writes the seat table into ctl1 / ctl2 and
 * the column headings (Away / Home plus the NHL city).
 */
#ifndef NHL95_SIDES_H
#define NHL95_SIDES_H

#include <stddef.h>
#include <stdint.h>

struct ob_sides;
struct ob_net;

void port_sides_init(void);
void port_sides_bind_net(struct ob_net *n);     /* same room as season: SIDES messages */
void port_sides_unbind_net(void);
struct ob_sides *port_sides_ob(void);

/* game thread: show the screen (every controller on this machine) and wait until
 * it starts or the player leaves. 1: the seat table was applied. 0: left / skipped. */
int port_sides_wait(void);
/* league H2H skips the select-sides screen. Same seat table exhibition netplay
 * applies: pad 0 home, pad 1 away, so F1-F8 and the faceoff box reach a team. */
void port_sides_h2h_seats(int home_machine, int vis_machine);
void port_sides_poll(void);                     /* main thread: open, devices, hotplug */

int port_sides_is_open(void);
/* the game slot of seat k (0, 1 the game's pads, 2, 3 pads 3 and 4; -1 none); before a sides screen, k */
int port_sides_slot_of_seat(int seat);
/* the game's pad 1 (slot 0) or 2 (slot 1) is the Game page's pretend controller: nobody plays it */
int port_sides_slot_fake(int slot);
void port_sides_draw(uint32_t *px, int w, int h, int pitch);
int port_sides_pad_input(int local, int mdrt_input);    /* 1: the screen used it */
/* F1-F8 / F9 / F10: 0 when this machine has no seat on that team. sc is the XT code. */
unsigned port_sides_filter_hot(unsigned sc, int machine);

/* seat -> the game's ctl* (tests). team 0 Away / 1 Home.
 * local 0 keyboard, SIDES_LOCAL_MOUSE the mouse, 1+ a pad. */
#define SIDES_LOCAL_MOUSE 16
void sides_seat_ctl(int team, int32_t home, int32_t vis, int32_t *ctl_team, uint32_t *ctl_side);
uint32_t sides_dev_for_slot(int slot, int local);       /* slot 0 ctl1, 1 ctl2 */
int sides_pad_index(int local);                         /* pads[] index, or -1 */
unsigned sides_filter_hot(unsigned sc, unsigned teams); /* teams bit 0 Away, bit 1 Home */

/* teamcitynames / teamabbrevs: BOS through ASE. The controls dialog draws these cities. */
#define SIDES_NTEAMS 28
/* Overbar stores and sends a column heading of this many characters (OB_SIDES_NAME). */
#define SIDES_LABEL_MAX 23

/* "Home Boston" / "Away Detroit". A null or empty city keeps the side word.
 * Longer than SIDES_LABEL_MAX is cut, and a byte outside ASCII becomes '?'. */
void sides_side_label(char *dst, size_t n, const char *side, const char *city);
/* cities[team], or NULL when team is outside 0 .. n-1 or that slot is empty.
 * Exhibition and a season game both index with the game's HomeTeam / VisTeam. */
const char *sides_city(const char *const *cities, int n, int team);
/* 1 when this machine's HomeTeam / VisTeam are the match: offline, or the host.
 * A guest's own teams are not (the host's headings arrive in the sides STATE). */
int sides_names_here(int online, int is_host);

/* The select-sides picture, the same boxes Overbar draws (ob_sides_draw at the pinned commit).
 * team -1 is the middle column. sides_drop_team returns -2 when the point is outside the panel. */
int sides_panel(int w, int h, int teams, int ndev, int *x0, int *y0, int *bw, int *cw);
int sides_drop_team(int x, int y, int w, int h, int teams, int ndev);
int sides_device_hit(int x, int y, int index, int team, int w, int h, int teams, int ndev);
/* presses that take a device from `from` to `to` (-1 middle, 0 away, 1 home). Each step is 0 left, 1 right. */
int sides_move_inputs(int from, int to, int *out);

/* game pixels. button is an SDL button (1 left, 3 right). what: 0 move, 1 down, 2 up.
 * Left-drag the Mouse row onto Away, the middle, or Home. 1 when the screen used it. */
int port_sides_pointer(int x, int y, int button, int what);

#endif
