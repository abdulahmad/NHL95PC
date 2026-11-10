/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * Manual goalie: 96 PC on-off and pad (B-hold, A dive, C save); 94 Genesis move and save anims.
 */
#ifndef NHL95_GOALIE_H
#define NHL95_GOALIE_H

#include <stdint.h>

void goalie_install(void);

/* 96 PC / 94G: B-hold. 0 wait, 1 take the goalie, 2 changeplayer (short B), 3 leave to original. */
enum { GB_WAIT, GB_TAKE, GB_CHANGE, GB_PASS };
int goalie_bhold(int manual, int on_goalie, int b_new, int b_held, int b_rel, uint8_t *timer);
int goalie_team_has_puck(int carrier, int sc);   /* carrier: the puck controller SortCords number, or -1 */

/* team's on-ice goalie slot: home 5, away 11 (96 PC / 94G FindGoalie). sc is the pad's player. */
int goalie_slot(int sc);

/* 94G crease: a human goalie here turns to the puck (goalieacc). */
int goalie_in_crease(int x, int y);

#endif
