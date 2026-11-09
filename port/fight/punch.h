/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * NHLPA 93's punch sound (port/fight/punch.c).
 */
#ifndef NHL95_PUNCH_H
#define NHL95_PUNCH_H

#include "rom93.h"

void punch_init(const rom93 *r);        /* after audio_init; the ROM stays loaded */
int punch_ready(void);                  /* 0: no ROM, the fight uses 95 PC's check sound */
void punch_play(int low);               /* any thread */

#endif
