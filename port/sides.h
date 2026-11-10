/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * 95 PC's hook for Overbar's select-sides screen (overbar/sides.h). The screen
 * itself is Overbar's; this file writes the seat table into ctl1 / ctl2.
 */
#ifndef NHL95_SIDES_H
#define NHL95_SIDES_H

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
void port_sides_poll(void);                     /* main thread: open, devices, hotplug */

int port_sides_is_open(void);
void port_sides_draw(uint32_t *px, int w, int h, int pitch);
int port_sides_pad_input(int local, int mdrt_input);    /* 1: the screen used it */
/* F1-F8 / F9 / F10: 0 when this machine has no seat on that team. sc is the XT code. */
unsigned port_sides_filter_hot(unsigned sc, int machine);

/* seat -> the game's ctl* (tests). team 0 Away / 1 Home. local 0 keyboard, 1+ a pad. */
void sides_seat_ctl(int team, int32_t home, int32_t vis, int32_t *ctl_team, uint32_t *ctl_side);
uint32_t sides_dev_for_slot(int slot, int local);       /* slot 0 ctl1, 1 ctl2 */
int sides_pad_index(int local);                         /* pads[] index, or -1 */
unsigned sides_filter_hot(unsigned sc, unsigned teams); /* teams bit 0 Away, bit 1 Home */

#endif
