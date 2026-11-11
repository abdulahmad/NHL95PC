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
int goalie_bhold(int manual, int on_goalie, int b_new, int b_held, int b_rel, uint8_t *timer, int button_mode);

/* team's on-ice goalie slot: home 5, away 11 (96 PC / 94G FindGoalie). sc is the pad's player. */
int goalie_slot(int sc);

/* 94G crease: a human goalie here turns to the puck (goalieacc). */
int goalie_in_crease(int x, int y);

/* puck y against 95 PC's blue line (0x58; 95 Genesis doinput_ispc uses $56). attack_up: pflags bit 7.
 * 1 offensive, -1 defensive, 0 between the blue lines. */
int goalie_zone(int y, int attack_up);

/* the Input bindings Manual goalie button. The bit is recorded in the pad byte (0x80) so both machines agree. */
void goalie_button_press(int slot);
int goalie_button_pull(int slot);

#endif
