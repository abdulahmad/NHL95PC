/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * NHLPA 93's fights in the game (port/fight/hooks.c, HOOKS.md).
 */
#ifndef NHL95_FIGHT_HOOKS_H
#define NHL95_FIGHT_HOOKS_H

#include <stdint.h>

void fight_install(void);                       /* from install_overrides, after feel_install */
void fight_check(uint8_t *a, uint8_t *b);       /* after checkcheck in checkcx */
void fight_frame(void);                         /* each DoGameFrame, before updateplayers */

#endif
